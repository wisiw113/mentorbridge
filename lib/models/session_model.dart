import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;

  final String mentorId;
  final String mentorName;

  final String title;
  final String description;

  final String date;
  final String startTime;
  final String endTime;

  final DateTime startAt;
  final DateTime endAt;

  final int maxSlots;
  final int bookedSlots;

  final String status;
  // open
  // full
  // running
  // completed
  // cancelled

  final DateTime createdAt;

  final String? fileUrl;
  final String? fileName;

  SessionModel({
    required this.id,
    required this.mentorId,
    required this.mentorName,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.startAt,
    required this.endAt,
    required this.maxSlots,
    required this.bookedSlots,
    required this.status,
    required this.createdAt,
    this.fileUrl,
    this.fileName,
  });

  factory SessionModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final created = map["createdAt"];
    final start = map["startAt"];
    final end = map["endAt"];

    return SessionModel(
      id: id,
      mentorId: map["mentorId"] ?? "",
      mentorName: map["mentorName"] ?? "",
      title: map["title"] ?? "",
      description: map["description"] ?? "",
      date: map["date"] ?? "",
      startTime: map["startTime"] ?? "",
      endTime: map["endTime"] ?? "",

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

      maxSlots:
          (map["maxSlots"] ?? 0) as int,

      bookedSlots:
          (map["bookedSlots"] ?? 0) as int,

      status:
          map["status"] ?? "open",

      createdAt: created is Timestamp
          ? created.toDate()
          : DateTime.tryParse(
                created?.toString() ?? "",
              ) ??
              DateTime.now(),

      fileUrl:
          map["fileUrl"],

      fileName:
          map["fileName"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "mentorId": mentorId,
      "mentorName": mentorName,

      "title": title,
      "description": description,

      "date": date,
      "startTime": startTime,
      "endTime": endTime,

      "startAt":
          Timestamp.fromDate(startAt),

      "endAt":
          Timestamp.fromDate(endAt),

      "maxSlots": maxSlots,
      "bookedSlots": bookedSlots,

      "status": status,

      "createdAt":
          Timestamp.fromDate(createdAt),

      "fileUrl": fileUrl,
      "fileName": fileName,
    };
  }

  SessionModel copyWith({
    String? mentorId,
    String? mentorName,

    String? title,
    String? description,

    String? date,
    String? startTime,
    String? endTime,

    DateTime? startAt,
    DateTime? endAt,

    int? maxSlots,
    int? bookedSlots,

    String? status,

    DateTime? createdAt,

    String? fileUrl,
    String? fileName,
  }) {
    return SessionModel(
      id: id,

      mentorId:
          mentorId ?? this.mentorId,

      mentorName:
          mentorName ?? this.mentorName,

      title:
          title ?? this.title,

      description:
          description ?? this.description,

      date:
          date ?? this.date,

      startTime:
          startTime ?? this.startTime,

      endTime:
          endTime ?? this.endTime,

      startAt:
          startAt ?? this.startAt,

      endAt:
          endAt ?? this.endAt,

      maxSlots:
          maxSlots ?? this.maxSlots,

      bookedSlots:
          bookedSlots ?? this.bookedSlots,

      status:
          status ?? this.status,

      createdAt:
          createdAt ?? this.createdAt,

      fileUrl:
          fileUrl ?? this.fileUrl,

      fileName:
          fileName ?? this.fileName,
    );
  }
}