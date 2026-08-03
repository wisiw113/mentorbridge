import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;

  final String chatId;

  final String senderId;
  final String senderName;

  final String message;

  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessageModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final created =
        map["createdAt"];

    return ChatMessageModel(
      id: id,

      chatId:
          map["chatId"] ?? "",

      senderId:
          map["senderId"] ?? "",

      senderName:
          map["senderName"] ?? "",

      message:
          map["message"] ?? "",

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
      "chatId": chatId,

      "senderId": senderId,
      "senderName": senderName,

      "message": message,

      "createdAt":
          Timestamp.fromDate(
        createdAt,
      ),
    };
  }

  ChatMessageModel copyWith({
    String? chatId,

    String? senderId,
    String? senderName,

    String? message,

    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id,

      chatId:
          chatId ?? this.chatId,

      senderId:
          senderId ?? this.senderId,

      senderName:
          senderName ?? this.senderName,

      message:
          message ?? this.message,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }
}