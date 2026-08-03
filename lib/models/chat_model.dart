import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;

  final String mentorId;
  final String mentorName;

  final String menteeId;
  final String menteeName;

  final String lastMessage;
  final DateTime lastMessageAt;

  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.mentorId,
    required this.mentorName,
    required this.menteeId,
    required this.menteeName,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory ChatModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final lastMessageTime =
        map["lastMessageAt"];

    final created =
        map["createdAt"];

    return ChatModel(
      id: id,

      mentorId:
          map["mentorId"] ?? "",

      mentorName:
          map["mentorName"] ?? "",

      menteeId:
          map["menteeId"] ?? "",

      menteeName:
          map["menteeName"] ?? "",

      lastMessage:
          map["lastMessage"] ?? "",

      lastMessageAt:
          lastMessageTime is Timestamp
              ? lastMessageTime.toDate()
              : DateTime.tryParse(
                    lastMessageTime
                            ?.toString() ??
                        "",
                  ) ??
                  DateTime.now(),

      createdAt:
          created is Timestamp
              ? created.toDate()
              : DateTime.tryParse(
                    created?.toString() ??
                        "",
                  ) ??
                  DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "mentorId": mentorId,
      "mentorName": mentorName,

      "menteeId": menteeId,
      "menteeName": menteeName,

      "lastMessage": lastMessage,

      "lastMessageAt":
          Timestamp.fromDate(
        lastMessageAt,
      ),

      "createdAt":
          Timestamp.fromDate(
        createdAt,
      ),
    };
  }

  ChatModel copyWith({
    String? mentorId,
    String? mentorName,

    String? menteeId,
    String? menteeName,

    String? lastMessage,
    DateTime? lastMessageAt,

    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id,

      mentorId:
          mentorId ?? this.mentorId,

      mentorName:
          mentorName ?? this.mentorName,

      menteeId:
          menteeId ?? this.menteeId,

      menteeName:
          menteeName ?? this.menteeName,

      lastMessage:
          lastMessage ?? this.lastMessage,

      lastMessageAt:
          lastMessageAt ??
              this.lastMessageAt,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }
}