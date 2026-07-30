import 'package:cloud_firestore/cloud_firestore.dart';

class SessionParticipantModel {
  final String id;

  final String sessionId;

  final String mentorId;

  final String menteeId;
  final String menteeName;

  final String status;
  // joined
  // left
  // completed

  final DateTime joinedAt;

  SessionParticipantModel({
    required this.id,
    required this.sessionId,
    required this.mentorId,
    required this.menteeId,
    required this.menteeName,
    required this.status,
    required this.joinedAt,
  });

  factory SessionParticipantModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final timestamp = map["joinedAt"];

    return SessionParticipantModel(
      id: id,
      sessionId: map["sessionId"] ?? "",
      mentorId: map["mentorId"] ?? "",
      menteeId: map["menteeId"] ?? "",
      menteeName: map["menteeName"] ?? "",
      status: map["status"] ?? "joined",
      joinedAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.tryParse(
                timestamp?.toString() ?? "",
              ) ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sessionId": sessionId,
      "mentorId": mentorId,
      "menteeId": menteeId,
      "menteeName": menteeName,
      "status": status,
      "joinedAt": Timestamp.fromDate(joinedAt),
    };
  }

  SessionParticipantModel copyWith({
    String? sessionId,
    String? mentorId,
    String? menteeId,
    String? menteeName,
    String? status,
    DateTime? joinedAt,
  }) {
    return SessionParticipantModel(
      id: id,
      sessionId: sessionId ?? this.sessionId,
      mentorId: mentorId ?? this.mentorId,
      menteeId: menteeId ?? this.menteeId,
      menteeName: menteeName ?? this.menteeName,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}