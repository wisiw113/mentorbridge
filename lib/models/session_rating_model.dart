import 'package:cloud_firestore/cloud_firestore.dart';

class SessionRatingModel {
  final String id;

  final String sessionId;
  final String mentorId;
  final String menteeId;

  final String mentorName;
  final String menteeName;

  final double rating;
  final String comment;

  final DateTime createdAt;

  SessionRatingModel({
    required this.id,
    required this.sessionId,
    required this.mentorId,
    required this.menteeId,
    required this.mentorName,
    required this.menteeName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory SessionRatingModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final timestamp = map['createdAt'];

    return SessionRatingModel(
      id: id,

      sessionId: map['sessionId'] ?? '',
      mentorId: map['mentorId'] ?? '',
      menteeId: map['menteeId'] ?? '',

      mentorName: map['mentorName'] ?? '',
      menteeName: map['menteeName'] ?? '',

      rating: map['rating'] is num
          ? (map['rating'] as num).toDouble()
          : 0.0,

      comment: map['comment'] ?? '',

      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.tryParse(
                timestamp?.toString() ?? '',
              ) ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'mentorId': mentorId,
      'menteeId': menteeId,
      'mentorName': mentorName,
      'menteeName': menteeName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SessionRatingModel copyWith({
    String? sessionId,
    String? mentorId,
    String? menteeId,
    String? mentorName,
    String? menteeName,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return SessionRatingModel(
      id: id,

      sessionId:
          sessionId ?? this.sessionId,

      mentorId:
          mentorId ?? this.mentorId,

      menteeId:
          menteeId ?? this.menteeId,

      mentorName:
          mentorName ?? this.mentorName,

      menteeName:
          menteeName ?? this.menteeName,

      rating:
          rating ?? this.rating,

      comment:
          comment ?? this.comment,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }
}