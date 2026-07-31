  import 'package:cloud_firestore/cloud_firestore.dart';
class AutoStatusService {
final FirebaseFirestore _firestore =
FirebaseFirestore.instance;
// =========================================================
// UPDATE ALL STATUSES
// =========================================================
Future<void> updateAllStatuses() async {
await updateAppointmentStatuses();
await updateSessionStatuses();
}

// =========================================================
// UPDATE APPOINTMENT STATUSES
// =========================================================
//
// pending + quá startAt
//      -> rejected
//
// accepted + quá endAt
//      -> completed
//
// =========================================================

Future<void> updateAppointmentStatuses() async {
final now = DateTime.now();

final snapshot = await _firestore
    .collection('appointments')
    .where(
      'status',
      whereIn: [
        'pending',
        'accepted',
      ],
    )
    .get();

if (snapshot.docs.isEmpty) {
  return;
}

final batch = _firestore.batch();

bool hasUpdates = false;

for (final doc in snapshot.docs) {
  final data = doc.data();

  final status = data['status'];

  final startAt = _parseTimestamp(
    data['startAt'],
  );

  final endAt = _parseTimestamp(
    data['endAt'],
  );

  if (startAt == null || endAt == null) {
    continue;
  }

  // =====================================================
  // PENDING -> REJECTED
  // =====================================================

  if (status == 'pending' &&
      !now.isBefore(startAt)) {
    batch.update(
      doc.reference,
      {
        'status': 'rejected',
        'rejectReason':
            'Mentor không chấp nhận Appointment trong thời gian quy định.',
        'autoRejected': true,
        'updatedAt':
            FieldValue.serverTimestamp(),
      },
    );

    hasUpdates = true;

    continue;
  }

  // =====================================================
  // ACCEPTED -> COMPLETED
  // =====================================================

  if (status == 'accepted' &&
      !now.isBefore(endAt)) {
    batch.update(
      doc.reference,
      {
        'status': 'completed',
        'autoCompleted': true,
        'updatedAt':
            FieldValue.serverTimestamp(),
      },
    );

    hasUpdates = true;
  }
}

if (hasUpdates) {
  await batch.commit();
}


}

// =========================================================
// UPDATE SESSION STATUSES
// =========================================================
//
// open + chưa tới giờ
//      -> giữ nguyên
//
// open + tới giờ + bookedSlots = 0
//      -> cancelled
//
// open + tới giờ + bookedSlots > 0
//      -> running
//
// open/running + quá endTime
//      -> completed
//
// cancelled/completed
//      -> không xử lý
//
// =========================================================

Future<void> updateSessionStatuses() async {
final snapshot = await _firestore
.collection('sessions')
.where(
'status',
whereIn: [
'open',
'running',
],
)
.get();


if (snapshot.docs.isEmpty) {
  return;
}

final batch = _firestore.batch();

bool hasUpdates = false;

final now = DateTime.now();

for (final doc in snapshot.docs) {
  final data = doc.data();

  final status = data['status'];

  final date = data['date']?.toString();

  final startTime =
      data['startTime']?.toString();

  final endTime =
      data['endTime']?.toString();

  if (date == null ||
      startTime == null ||
      endTime == null) {
    continue;
  }

  final startAt =
      _parseSessionDateTime(
    date,
    startTime,
  );

  final endAt =
      _parseSessionDateTime(
    date,
    endTime,
  );

  if (startAt == null ||
      endAt == null) {
    continue;
  }

  // =====================================================
  // SESSION CHƯA BẮT ĐẦU
  // =====================================================

  if (now.isBefore(startAt)) {
    continue;
  }

  // =====================================================
  // SESSION ĐÃ TỚI GIỜ BẮT ĐẦU
  // =====================================================

  if (now.isBefore(endAt)) {
    final bookedSlots =
        _parseInt(
      data['bookedSlots'],
    );

    // ===============================================
    // OPEN -> CANCELLED
    // ===============================================

    if (status == 'open' &&
        bookedSlots <= 0) {
      batch.update(
        doc.reference,
        {
          'status': 'cancelled',
          'cancelReason':
              'Session tự động hủy vì không có người tham gia.',
          'autoCancelled': true,
          'updatedAt':
              FieldValue.serverTimestamp(),
        },
      );

      hasUpdates = true;

      continue;
    }

    // ===============================================
    // OPEN -> RUNNING
    // ===============================================

    if (status == 'open' &&
        bookedSlots > 0) {
      batch.update(
        doc.reference,
        {
          'status': 'running',
          'autoStarted': true,
          'updatedAt':
              FieldValue.serverTimestamp(),
        },
      );

      hasUpdates = true;

      continue;
    }

    // Session đang running thì giữ nguyên.
    continue;
  }

  // =====================================================
  // SESSION ĐÃ HẾT GIỜ
  // =====================================================

  if (!now.isBefore(endAt)) {
    if (status == 'open' ||
        status == 'running') {
      batch.update(
        doc.reference,
        {
          'status': 'completed',
          'autoCompleted': true,
          'updatedAt':
              FieldValue.serverTimestamp(),
        },
      );

      hasUpdates = true;
    }
  }
}

if (hasUpdates) {
  await batch.commit();
}

}

// =========================================================
// UPDATE SINGLE APPOINTMENT
// =========================================================
//
// Dùng khi mở Appointment Detail.
//
// Trả về status mới.
//
// =========================================================

Future<String?> updateSingleAppointment(
String appointmentId,
) async {
final appointmentRef = _firestore
.collection('appointments')
.doc(appointmentId);


final snapshot =
    await appointmentRef.get();

if (!snapshot.exists) {
  return null;
}

final data = snapshot.data();

if (data == null) {
  return null;
}

final status = data['status'];

final now = DateTime.now();

final startAt = _parseTimestamp(
  data['startAt'],
);

final endAt = _parseTimestamp(
  data['endAt'],
);

if (startAt == null ||
    endAt == null) {
  return status?.toString();
}

// =====================================================
// PENDING -> REJECTED
// =====================================================

if (status == 'pending' &&
    !now.isBefore(startAt)) {
  await appointmentRef.update({
    'status': 'rejected',
    'rejectReason':
        'Mentor không chấp nhận Appointment trong thời gian quy định.',
    'autoRejected': true,
    'updatedAt':
        FieldValue.serverTimestamp(),
  });

  return 'rejected';
}

// =====================================================
// ACCEPTED -> COMPLETED
// =====================================================

if (status == 'accepted' &&
    !now.isBefore(endAt)) {
  await appointmentRef.update({
    'status': 'completed',
    'autoCompleted': true,
    'updatedAt':
        FieldValue.serverTimestamp(),
  });

  return 'completed';
}

return status?.toString();


}

// =========================================================
// UPDATE SINGLE SESSION
// =========================================================
//
// Dùng khi mở Session Detail.
//
// Trả về Session status mới.
//
// =========================================================

Future<String?> updateSingleSession(
String sessionId,
) async {
final sessionRef = _firestore
.collection('sessions')
.doc(sessionId);


final snapshot =
    await sessionRef.get();

if (!snapshot.exists) {
  return null;
}

final data = snapshot.data();

if (data == null) {
  return null;
}

final status = data['status'];

// Không xử lý trạng thái cuối.
if (status == 'cancelled' ||
    status == 'completed') {
  return status?.toString();
}

final date =
    data['date']?.toString();

final startTime =
    data['startTime']?.toString();

final endTime =
    data['endTime']?.toString();

if (date == null ||
    startTime == null ||
    endTime == null) {
  return status?.toString();
}

final startAt =
    _parseSessionDateTime(
  date,
  startTime,
);

final endAt =
    _parseSessionDateTime(
  date,
  endTime,
);

if (startAt == null ||
    endAt == null) {
  return status?.toString();
}

final now = DateTime.now();

// =====================================================
// CHƯA TỚI GIỜ
// =====================================================

if (now.isBefore(startAt)) {
  return status?.toString();
}

// =====================================================
// TỚI GIỜ NHƯNG CHƯA KẾT THÚC
// =====================================================

if (now.isBefore(endAt)) {
  final bookedSlots =
      _parseInt(
    data['bookedSlots'],
  );

  // OPEN -> CANCELLED
  if (status == 'open' &&
      bookedSlots <= 0) {
    await sessionRef.update({
      'status': 'cancelled',
      'cancelReason':
          'Session tự động hủy vì không có người tham gia.',
      'autoCancelled': true,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });

    return 'cancelled';
  }

  // OPEN -> RUNNING
  if (status == 'open' &&
      bookedSlots > 0) {
    await sessionRef.update({
      'status': 'running',
      'autoStarted': true,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });

    return 'running';
  }

  return status?.toString();
}

// =====================================================
// HẾT GIỜ
// =====================================================

if (status == 'open' ||
    status == 'running') {
  await sessionRef.update({
    'status': 'completed',
    'autoCompleted': true,
    'updatedAt':
        FieldValue.serverTimestamp(),
  });

  return 'completed';
}

return status?.toString();

}

// =========================================================
// PARSE FIRESTORE TIMESTAMP
// =========================================================

DateTime? _parseTimestamp(
dynamic value,
) {
if (value is Timestamp) {
return value.toDate();
}

if (value is DateTime) {
  return value;
}

if (value is String) {
  return DateTime.tryParse(value);
}

return null;


}

// =========================================================
// PARSE INT
// =========================================================

int _parseInt(
dynamic value,
) {
if (value is int) {
return value;
}

if (value is num) {
  return value.toInt();
}

if (value is String) {
  return int.tryParse(value) ?? 0;
}

return 0;


}

// =========================================================
// PARSE SESSION DATETIME
// =========================================================
//
// Firestore:
//
// date      = "2026-07-30"
// startTime = "14:00"
// endTime   = "15:00"
//
// Session được lưu theo giờ Việt Nam.
//
// Việt Nam = UTC+7
//
// 14:00 Việt Nam
// =
// 07:00 UTC
//
// Hàm này chuyển thời gian Session
// sang DateTime UTC để so sánh chính xác.
//
// =========================================================

DateTime? _parseSessionDateTime(
String date,
String time,
) {
try {
final dateParts =
date.split('-');


  final timeParts =
      time.split(':');

  if (dateParts.length != 3 ||
      timeParts.length < 2) {
    return null;
  }

  final year =
      int.parse(dateParts[0]);

  final month =
      int.parse(dateParts[1]);

  final day =
      int.parse(dateParts[2]);

  final hour =
      int.parse(timeParts[0]);

  final minute =
      int.parse(timeParts[1]);

  if (hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59) {
    return null;
  }

  // Session time đang là giờ Việt Nam.
  //
  // Chuyển sang UTC:
  // Việt Nam UTC+7
  // => trừ 7 giờ.

  return DateTime.utc(
    year,
    month,
    day,
    hour - 7,
    minute,
  );
} catch (_) {
  return null;
}


}
}
