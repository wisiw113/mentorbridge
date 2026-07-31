
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentRatingModel {
  final String id;

  final String mentorId;
  final String menteeId;
  final String appointmentId;

  final String mentorName;
  final String menteeName;

  final double rating;
  final String comment;

  final DateTime createdAt;

  AppointmentRatingModel({
    required this.id,
    required this.mentorId,
    required this.menteeId,
    required this.appointmentId,
    required this.mentorName,
    required this.menteeName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory AppointmentRatingModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final timestamp = map['createdAt'];

    return AppointmentRatingModel(
      id: id,

      mentorId: map['mentorId'] ?? '',
      menteeId: map['menteeId'] ?? '',
      appointmentId: map['appointmentId'] ?? '',

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
      'mentorId': mentorId,
      'menteeId': menteeId,
      'appointmentId': appointmentId,
      'mentorName': mentorName,
      'menteeName': menteeName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppointmentRatingModel copyWith({
    String? mentorId,
    String? menteeId,
    String? appointmentId,
    String? mentorName,
    String? menteeName,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return AppointmentRatingModel(
      id: id,

      mentorId:
          mentorId ?? this.mentorId,

      menteeId:
          menteeId ?? this.menteeId,

      appointmentId:
          appointmentId ?? this.appointmentId,

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

