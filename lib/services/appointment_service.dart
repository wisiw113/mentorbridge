import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';

class AppointmentService {
final FirebaseFirestore _firestore =
FirebaseFirestore.instance;

// =========================================================
// CREATE APPOINTMENT
// =========================================================

Future<void> createAppointment(
AppointmentModel model,
) async {
await _firestore
.collection('appointments')
.add(
model.toMap(),
);
}

// =========================================================
// BOOK APPOINTMENT
// =========================================================

Future<void> bookAppointment(
AppointmentModel model,
) async {
// Không cho phép đặt lịch trong quá khứ
if (model.startAt.isBefore(DateTime.now())) {
throw Exception(
"Không thể đặt lịch trong quá khứ.",
);
}


// =======================================================
// CHECK MENTOR'S SCHEDULE
// =======================================================

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
  final appointment =
      AppointmentModel.fromMap(
    doc.id,
    doc.data(),
  );

  final isOverlapping =
      _isTimeOverlapping(
    model.startAt,
    model.endAt,
    appointment.startAt,
    appointment.endAt,
  );

  if (isOverlapping) {
    throw Exception(
      "Mentor đã có lịch trong khoảng thời gian này.",
    );
  }
}

// =======================================================
// CHECK MENTEE'S SCHEDULE
// =======================================================

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
  final appointment =
      AppointmentModel.fromMap(
    doc.id,
    doc.data(),
  );

  final isOverlapping =
      _isTimeOverlapping(
    model.startAt,
    model.endAt,
    appointment.startAt,
    appointment.endAt,
  );

  if (isOverlapping) {
    throw Exception(
      "Bạn đã có một lịch hẹn khác trong khoảng thời gian này.",
    );
  }
}

// =======================================================
// CREATE
// =======================================================

await createAppointment(model);


}

// =========================================================
// CHECK TIME OVERLAP
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
// GET MENTEE APPOINTMENTS
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
.map(
(snapshot) {
return snapshot.docs
.map(
(doc) =>
AppointmentModel.fromMap(
doc.id,
doc.data(),
),
)
.toList();
},
);
}

// =========================================================
// GET MENTOR REQUESTS
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
.map(
(snapshot) {
return snapshot.docs
.map(
(doc) =>
AppointmentModel.fromMap(
doc.id,
doc.data(),
),
)
.toList();
},
);
}

// =========================================================
// UPDATE APPOINTMENT STATUS
// =========================================================

Future<void> updateStatus(
String id,
String status, {
String? rejectReason,
}) async {
final Map<String, dynamic> data = {
'status': status,
};


// Nếu appointment bị từ chối
// và có lý do thì lưu lý do
if (status == 'rejected' &&
    rejectReason != null &&
    rejectReason.trim().isNotEmpty) {
  data['rejectReason'] =
      rejectReason.trim();
}

await _firestore
    .collection('appointments')
    .doc(id)
    .update(data);


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
}
