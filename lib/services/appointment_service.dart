import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/rating_model.dart';
import '../models/appointment_model.dart';

class AppointmentService {
final FirebaseFirestore _firestore =
FirebaseFirestore.instance;
Future<void> createAppointment(
AppointmentModel model,
) async {
await _firestore
.collection('appointments')
.add(
model.toMap(),
);
}

Future<void> bookAppointment(
AppointmentModel model,
) async {
final now = DateTime.now();

if (!model.startAt.isAfter(now)) {
  throw Exception(
    "Không thể đặt lịch trong quá khứ.",
  );
}

if (!model.endAt.isAfter(model.startAt)) {
  throw Exception(
    "Thời gian kết thúc phải sau thời gian bắt đầu.",
  );
}

final mentorAppointments =
    await _firestore
        .collection('appointments')
        .where(
          'mentorId',
          isEqualTo: model.mentorId,
        )
        .where(
          'status',
          whereIn: [
            'pending',
            'accepted',
          ],
        )
        .get();

for (final doc
    in mentorAppointments.docs) {
  // Không so sánh chính appointment hiện tại
  if (doc.id == model.id) {
    continue;
  }

  final appointment =
      AppointmentModel.fromMap(
    doc.id,
    doc.data(),
  );

  if (_isTimeOverlapping(
    model.startAt,
    model.endAt,
    appointment.startAt,
    appointment.endAt,
  )) {
    throw Exception(
      "Mentor đã có một lịch hẹn khác trong khoảng thời gian này.",
    );
  }
}

final menteeAppointments =
    await _firestore
        .collection('appointments')
        .where(
          'menteeId',
          isEqualTo: model.menteeId,
        )
        .where(
          'status',
          whereIn: [
            'pending',
            'accepted',
          ],
        )
        .get();

for (final doc
    in menteeAppointments.docs) {
  if (doc.id == model.id) {
    continue;
  }

  final appointment =
      AppointmentModel.fromMap(
    doc.id,
    doc.data(),
  );

  if (_isTimeOverlapping(
    model.startAt,
    model.endAt,
    appointment.startAt,
    appointment.endAt,
  )) {
    throw Exception(
      "Bạn đã có một lịch hẹn khác trong khoảng thời gian này.",
    );
  }
}

// =======================================================
// CHECK MENTOR SESSION
// =======================================================

final mentorSessions =
    await _firestore
        .collection('sessions')
        .where(
          'mentorId',
          isEqualTo: model.mentorId,
        )
        .where(
          'status',
          whereIn: [
            'open',
            'running',
          ],
        )
        .get();

for (final doc
    in mentorSessions.docs) {
  final data = doc.data();

  final sessionStart =
      _parseSessionDateTime(
    data['date'],
    data['startTime'],
  );

  final sessionEnd =
      _parseSessionDateTime(
    data['date'],
    data['endTime'],
  );

  if (sessionStart == null ||
      sessionEnd == null) {
    continue;
  }

  if (_isTimeOverlapping(
    model.startAt,
    model.endAt,
    sessionStart,
    sessionEnd,
  )) {
    throw Exception(
      "Mentor đã có Session trong khoảng thời gian này.",
    );
  }
}

// =======================================================
// CHECK MENTEE SESSION
// =======================================================

final menteeParticipants =
    await _firestore
        .collection(
          'session_participants',
        )
        .where(
          'menteeId',
          isEqualTo: model.menteeId,
        )
        .where(
          'status',
          isEqualTo: 'joined',
        )
        .get();

for (final participant
    in menteeParticipants.docs) {
  final sessionId =
      participant.data()['sessionId'];

  if (sessionId == null) {
    continue;
  }

  final sessionDoc =
      await _firestore
          .collection('sessions')
          .doc(sessionId)
          .get();

  if (!sessionDoc.exists) {
    continue;
  }

  final data =
      sessionDoc.data();

  if (data == null) {
    continue;
  }

  final sessionStart =
      _parseSessionDateTime(
    data['date'],
    data['startTime'],
  );

  final sessionEnd =
      _parseSessionDateTime(
    data['date'],
    data['endTime'],
  );

  if (sessionStart == null ||
      sessionEnd == null) {
    continue;
  }

  if (_isTimeOverlapping(
    model.startAt,
    model.endAt,
    sessionStart,
    sessionEnd,
  )) {
    throw Exception(
      "Bạn đã tham gia một Session trong khoảng thời gian này.",
    );
  }
}

// =======================================================
// CREATE
// =======================================================

await createAppointment(model);


}

Future<void> updateStatus(
String id,
String status, {
String? rejectReason,
}) async {
final appointmentRef =
_firestore
.collection('appointments')
.doc(id);


final appointmentSnapshot =
    await appointmentRef.get();

if (!appointmentSnapshot.exists) {
  throw Exception(
    "Appointment không tồn tại.",
  );
}

// Không dùng data()!
final appointmentData =
    appointmentSnapshot.data();

if (appointmentData == null) {
  throw Exception(
    "Không thể đọc dữ liệu Appointment.",
  );
}

final appointment =
    AppointmentModel.fromMap(
  appointmentSnapshot.id,
  appointmentData,
);

if (status == 'accepted') {
  if (appointment.status !=
      'pending') {
    throw Exception(
      "Appointment này không còn ở trạng thái chờ xử lý.",
    );
  }

  if (!appointment.startAt
      .isAfter(DateTime.now())) {
    await appointmentRef.update({
      'status': 'rejected',
      'rejectReason':
          'Mentor không chấp nhận Appointment trong thời gian quy định.',
    });

    throw Exception(
      "Appointment đã quá thời gian chấp nhận.",
    );
  }

  // Kiểm tra appointment khác của mentor
  final mentorAppointments =
      await _firestore
          .collection('appointments')
          .where(
            'mentorId',
            isEqualTo:
                appointment.mentorId,
          )
          .where(
            'status',
            whereIn: [
              'pending',
              'accepted',
            ],
          )
          .get();

  for (final doc
      in mentorAppointments.docs) {
    if (doc.id == id) {
      continue;
    }

    final otherAppointment =
        AppointmentModel.fromMap(
      doc.id,
      doc.data(),
    );

    if (_isTimeOverlapping(
      appointment.startAt,
      appointment.endAt,
      otherAppointment.startAt,
      otherAppointment.endAt,
    )) {
      throw Exception(
        "Mentor đã có một Appointment khác trong khoảng thời gian này.",
      );
    }
  }

  final mentorSessions =
      await _firestore
          .collection('sessions')
          .where(
            'mentorId',
            isEqualTo:
                appointment.mentorId,
          )
          .where(
            'status',
            whereIn: [
              'open',
              'running',
            ],
          )
          .get();

  for (final doc
      in mentorSessions.docs) {
    final data = doc.data();

    final sessionStart =
        _parseSessionDateTime(
      data['date'],
      data['startTime'],
    );

    final sessionEnd =
        _parseSessionDateTime(
      data['date'],
      data['endTime'],
    );

    if (sessionStart == null ||
        sessionEnd == null) {
      continue;
    }

    if (_isTimeOverlapping(
      appointment.startAt,
      appointment.endAt,
      sessionStart,
      sessionEnd,
    )) {
      throw Exception(
        "Không thể chấp nhận Appointment vì Mentor đã có Session trong khoảng thời gian này.",
      );
    }
  }
}

// =======================================================
// REJECT
// =======================================================

final data =
    <String, dynamic>{
  'status': status,
};

if (status == 'rejected' &&
    rejectReason != null &&
    rejectReason
        .trim()
        .isNotEmpty) {
  data['rejectReason'] =
      rejectReason.trim();
}

await appointmentRef.update(data);


}

Future<AppointmentModel>
_updateAppointmentStatus(
AppointmentModel appointment,
) async {
final now = DateTime.now();

// =======================================================
// PENDING QUÁ GIỜ
// =======================================================

if (appointment.status ==
        'pending' &&
    now.isAfter(
      appointment.startAt,
    )) {
  final reason =
      'Mentor không chấp nhận Appointment trong thời gian quy định.';

  await _firestore
      .collection('appointments')
      .doc(appointment.id)
      .update({
    'status': 'rejected',
    'rejectReason': reason,
  });

  return appointment.copyWith(
    status: 'rejected',
    rejectReason: reason,
  );
}

// =======================================================
// ACCEPTED HẾT GIỜ
// =======================================================

if (appointment.status ==
        'accepted' &&
    now.isAfter(
      appointment.endAt,
    )) {
  await _firestore
      .collection('appointments')
      .doc(appointment.id)
      .update({
    'status': 'completed',
  });

  return appointment.copyWith(
    status: 'completed',
  );
}

return appointment;

}

// =========================================================
// MENTEE APPOINTMENTS
// =========================================================

Stream<List<AppointmentModel>>
getMenteeAppointments(
String menteeId,
) {
return _firestore
.collection('appointments')
.where(
'menteeId',
isEqualTo: menteeId,
)
.snapshots()
.asyncMap(
(snapshot) async {
final appointments = <AppointmentModel>[];

    for (final doc
        in snapshot.docs) {
      final appointment =
          AppointmentModel.fromMap(
        doc.id,
        doc.data(),
      );

      final updated =
          await _updateAppointmentStatus(
        appointment,
      );

      appointments.add(updated);
    }

    return appointments;
  },
);


}

// =========================================================
// MENTOR REQUESTS
// =========================================================

Stream<List<AppointmentModel>>
getMentorRequests(
String mentorId,
) {
return _firestore
.collection('appointments')
.where(
'mentorId',
isEqualTo: mentorId,
)
.snapshots()
.asyncMap(
(snapshot) async {
final appointments = <AppointmentModel>[];

    for (final doc
        in snapshot.docs) {
      final appointment =
          AppointmentModel.fromMap(
        doc.id,
        doc.data(),
      );

      final updated =
          await _updateAppointmentStatus(
        appointment,
      );

      appointments.add(updated);
    }

    return appointments;
  },
);


}

// =========================================================
// CANCEL APPOINTMENT
// =========================================================

Future<void> cancelAppointment(
String id,
) async {
await _firestore
.collection('appointments')
.doc(id)
.delete();
}

// =========================================================
// RATE MENTOR
// =========================================================

Future<void> rateMentor({
required String mentorId,
required String appointmentId,
required int rating,
}) async {
if (rating < 1 || rating > 5) {
throw Exception(
"Đánh giá phải từ 1 đến 5 sao.",
);
}

final user =
    FirebaseAuth
        .instance
        .currentUser;

if (user == null) {
  throw Exception(
    "Bạn chưa đăng nhập.",
  );
}

await _firestore.runTransaction(
  (transaction) async {
    final appointmentRef =
        _firestore
            .collection(
              "appointments",
            )
            .doc(appointmentId);

    final appointmentSnapshot =
        await transaction.get(
      appointmentRef,
    );

    if (!appointmentSnapshot
        .exists) {
      throw Exception(
        "Appointment không tồn tại.",
      );
    }

    // Không dùng data()!
    final appointmentData =
        appointmentSnapshot.data();

    if (appointmentData == null) {
      throw Exception(
        "Không thể đọc dữ liệu Appointment.",
      );
    }

    if (appointmentData["rated"] ==
        true) {
      throw Exception(
        "Appointment này đã được đánh giá.",
      );
    }

    if (appointmentData["status"] !=
        "completed") {
      throw Exception(
        "Chỉ có thể đánh giá Appointment đã hoàn thành.",
      );
    }

    transaction.update(
      appointmentRef,
      {
        "rated": true,
      },
    );

    final ratingRef =
        _firestore
            .collection("ratings")
            .doc();

    transaction.set(
      ratingRef,
      {
        "mentorId": mentorId,
        "menteeId": user.uid,
        "appointmentId":
            appointmentId,
        "rating": rating,
        "createdAt":
            FieldValue
                .serverTimestamp(),
      },
    );
  },
);


}

// =========================================================
// GET RATING BY APPOINTMENT
// =========================================================

Future<RatingModel?>
getRatingByAppointment(
String appointmentId,
) async {
final snapshot =
await _firestore
.collection('ratings')
.where(
'appointmentId',
isEqualTo:
appointmentId,
)
.limit(1)
.get();


if (snapshot.docs.isEmpty) {
  return null;
}

final doc =
    snapshot.docs.first;

return RatingModel.fromMap(
  doc.id,
  doc.data(),
);


}

// =========================================================
// CHECK OVERLAPPING
// =========================================================

bool _isTimeOverlapping(
DateTime start1,
DateTime end1,
DateTime start2,
DateTime end2,
) {
return start1.isBefore(end2) &&
end1.isAfter(start2);
}

// =========================================================
// PARSE SESSION DATETIME
// =========================================================

DateTime? _parseSessionDateTime(
dynamic date,
dynamic time,
) {
if (date == null ||
time == null) {
return null;
}


try {
  final dateString =
      date.toString();

  final timeString =
      time.toString();

  final dateParts =
      dateString.split("-");

  final timeParts =
      timeString.split(":");

  if (dateParts.length != 3 ||
      timeParts.length < 2) {
    return null;
  }

  return DateTime(
    int.parse(dateParts[0]),
    int.parse(dateParts[1]),
    int.parse(dateParts[2]),
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );
} catch (_) {
  return null;
}

}
}
