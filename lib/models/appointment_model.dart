import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;

  final String mentorId;
  final String menteeId;

  final String mentorName;
  final String menteeName;

  /// yyyy-MM-dd
  final String date;

  /// 08:00
  final String startTime;

  /// 10:00
  final String endTime;

  /// 08:00 - 10:00
  final String time;

  /// Chủ đề tư vấn
  final String topic;

  /// Ghi chú của Mentee
  final String note;

  /// pending
  /// accepted
  /// rejected
  /// cancelled
  /// completed
  final String status;

  /// Lý do từ chối
  final String? rejectReason;

  /// Lý do hủy
  final String? cancelReason;

  /// Mentee đã rating chưa
  final bool rated;

  /// Thời gian bắt đầu
  final DateTime startAt;

  /// Thời gian kết thúc
  final DateTime endAt;

  /// Thời gian tạo Appointment
  final DateTime createdAt;

  const AppointmentModel({
    required this.id,
    required this.mentorId,
    required this.menteeId,
    required this.mentorName,
    required this.menteeName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.time,
    required this.topic,
    required this.note,
    required this.status,
    this.rejectReason,
    this.cancelReason,
    required this.rated,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
  });

  // =========================================================
  // FROM FIRESTORE
  // =========================================================

  factory AppointmentModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return AppointmentModel(
      id: id,

      mentorId:
          map['mentorId']?.toString() ?? '',

      menteeId:
          map['menteeId']?.toString() ?? '',

      mentorName:
          map['mentorName']?.toString() ?? '',

      menteeName:
          map['menteeName']?.toString() ?? '',

      date:
          map['date']?.toString() ?? '',

      startTime:
          map['startTime']?.toString() ?? '',

      endTime:
          map['endTime']?.toString() ?? '',

      time:
          map['time']?.toString() ?? '',

      topic:
          map['topic']?.toString() ?? '',

      note:
          map['note']?.toString() ?? '',

      status:
          map['status']?.toString() ?? 'pending',

      rejectReason:
          map['rejectReason']?.toString(),

      cancelReason:
          map['cancelReason']?.toString(),

      rated:
          map['rated'] == true,

      startAt:
          _parseDateTime(map['startAt']),

      endAt:
          _parseDateTime(map['endAt']),

      createdAt:
          _parseDateTime(map['createdAt']),
    );
  }

  // =========================================================
  // TO FIRESTORE
  // =========================================================

  Map<String, dynamic> toMap() {
    return {
      'mentorId': mentorId,
      'menteeId': menteeId,

      'mentorName': mentorName,
      'menteeName': menteeName,

      'date': date,

      'startTime': startTime,
      'endTime': endTime,

      'time': time,

      'topic': topic,

      'note': note,

      'status': status,

      'rejectReason': rejectReason,

      'cancelReason': cancelReason,

      'rated': rated,

      'startAt':
          Timestamp.fromDate(startAt),

      'endAt':
          Timestamp.fromDate(endAt),

      'createdAt':
          Timestamp.fromDate(createdAt),
    };
  }

  // =========================================================
  // PARSE DATETIME
  // =========================================================

  static DateTime _parseDateTime(
    dynamic value,
  ) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value != null) {
      final parsed =
          DateTime.tryParse(
        value.toString(),
      );

      if (parsed != null) {
        return parsed;
      }
    }

    return DateTime.now();
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  AppointmentModel copyWith({
    String? mentorId,
    String? menteeId,
    String? mentorName,
    String? menteeName,
    String? date,
    String? startTime,
    String? endTime,
    String? time,
    String? topic,
    String? note,
    String? status,
    String? rejectReason,
    String? cancelReason,
    bool? rated,
    DateTime? startAt,
    DateTime? endAt,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id,

      mentorId:
          mentorId ?? this.mentorId,

      menteeId:
          menteeId ?? this.menteeId,

      mentorName:
          mentorName ?? this.mentorName,

      menteeName:
          menteeName ?? this.menteeName,

      date:
          date ?? this.date,

      startTime:
          startTime ?? this.startTime,

      endTime:
          endTime ?? this.endTime,

      time:
          time ?? this.time,

      topic:
          topic ?? this.topic,

      note:
          note ?? this.note,

      status:
          status ?? this.status,

      rejectReason:
          rejectReason ?? this.rejectReason,

      cancelReason:
          cancelReason ?? this.cancelReason,

      rated:
          rated ?? this.rated,

      startAt:
          startAt ?? this.startAt,

      endAt:
          endAt ?? this.endAt,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }
} 