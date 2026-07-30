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

  final String note;

  final String status;
  // pending
  // accepted
  // rejected
  // completed

  final String? rejectReason;

  final bool rated;

  /// Thời gian bắt đầu thực tế
  final DateTime startAt;

  /// Thời gian kết thúc thực tế
  final DateTime endAt;

  final DateTime createdAt;

  AppointmentModel({
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
    required this.rated,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
  });

  factory AppointmentModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final created = map["createdAt"];
    final start = map["startAt"];
    final end = map["endAt"];

    return AppointmentModel(
      id: id,
      mentorId: map["mentorId"] ?? "",
      menteeId: map["menteeId"] ?? "",
      mentorName: map["mentorName"] ?? "",
      menteeName: map["menteeName"] ?? "",
      date: map["date"] ?? "",
      startTime: map["startTime"] ?? "",
      endTime: map["endTime"] ?? "",
      time: map["time"] ?? "",
      topic: map["topic"] ?? "",
      note: map["note"] ?? "",
      status: map["status"] ?? "pending",
      rejectReason: map["rejectReason"],
      rated: map["rated"] ?? false,

      startAt: start is Timestamp
          ? start.toDate()
          : DateTime.tryParse(
                start?.toString() ?? "",
              ) ??
              DateTime.now(),

      endAt: end is Timestamp
          ? end.toDate()
          : DateTime.tryParse(
                end?.toString() ?? "",
              ) ??
              DateTime.now(),

      createdAt: created is Timestamp
          ? created.toDate()
          : DateTime.tryParse(
                created?.toString() ?? "",
              ) ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "mentorId": mentorId,
      "menteeId": menteeId,
      "mentorName": mentorName,
      "menteeName": menteeName,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "time": time,
      "topic": topic,
      "note": note,
      "status": status,
      "rejectReason": rejectReason,
      "rated": rated,
      "startAt": Timestamp.fromDate(startAt),
      "endAt": Timestamp.fromDate(endAt),
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

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
    bool? rated,
    DateTime? startAt,
    DateTime? endAt,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id,
      mentorId: mentorId ?? this.mentorId,
      menteeId: menteeId ?? this.menteeId,
      mentorName: mentorName ?? this.mentorName,
      menteeName: menteeName ?? this.menteeName,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      time: time ?? this.time,
      topic: topic ?? this.topic,
      note: note ?? this.note,
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
      rated: rated ?? this.rated,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}