import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;

  final String userId;

  final String title;

  final String message;

  final String type;

  final String? relatedId;

  final bool isRead;

  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
  });

  // =========================================================
  // FROM FIRESTORE
  // =========================================================

  factory NotificationModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return NotificationModel(
      id: id,

      userId:
          map['userId']?.toString() ?? '',

      title:
          map['title']?.toString() ?? '',

      message:
          map['message']?.toString() ?? '',

      type:
          map['type']?.toString() ?? 'general',

      relatedId:
          map['relatedId']?.toString(),

      isRead:
          map['isRead'] == true,

      createdAt:
          _parseDateTime(
        map['createdAt'],
      ),
    );
  }

  // =========================================================
  // TO FIRESTORE
  // =========================================================

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,

      'title': title,

      'message': message,

      'type': type,

      'relatedId': relatedId,

      'isRead': isRead,

      'createdAt':
          Timestamp.fromDate(
        createdAt,
      ),
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

    if (value is String) {
      return DateTime.tryParse(
            value,
          ) ??
          DateTime.now();
    }

    return DateTime.now();
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    String? relatedId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      relatedId:
          relatedId ?? this.relatedId,
      isRead:
          isRead ?? this.isRead,
      createdAt:
          createdAt ?? this.createdAt,
    );
  }
}