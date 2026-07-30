import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/rating_model.dart';

class RatingService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ================= CREATE RATING =================

  Future<void> createRating(
    RatingModel rating,
  ) async {
    // Kiểm tra mentee đã đánh giá appointment này chưa
    final existing = await _firestore
        .collection('ratings')
        .where(
          'appointmentId',
          isEqualTo: rating.appointmentId,
        )
        .where(
          'menteeId',
          isEqualTo: rating.menteeId,
        )
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception(
        'Bạn đã đánh giá appointment này rồi.',
      );
    }

    await _firestore
        .collection('ratings')
        .add(
          rating.toMap(),
        );
  }

  // ================= GET MENTOR RATINGS =================

  Stream<List<RatingModel>> getMentorRatings(
    String mentorId,
  ) {
    return _firestore
        .collection('ratings')
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (doc) => RatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();
          },
        );
  }

  // ================= GET ALL MENTOR RATINGS =================

  Future<List<RatingModel>> getMentorRatingsOnce(
    String mentorId,
  ) async {
    final snapshot = await _firestore
        .collection('ratings')
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => RatingModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }

  // ================= GET AVERAGE RATING =================

  Future<double> getMentorAverageRating(
    String mentorId,
  ) async {
    final ratings =
        await getMentorRatingsOnce(
      mentorId,
    );

    if (ratings.isEmpty) {
      return 0.0;
    }

    double total = 0;

    for (final rating in ratings) {
      total += rating.rating;
    }

    return total / ratings.length;
  }

  // ================= GET REVIEW COUNT =================

  Future<int> getMentorReviewCount(
    String mentorId,
  ) async {
    final snapshot = await _firestore
        .collection('ratings')
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .get();

    return snapshot.docs.length;
  }

  // ================= GET RATING SUMMARY =================

  Future<Map<String, dynamic>>
      getMentorRatingSummary(
    String mentorId,
  ) async {
    final ratings =
        await getMentorRatingsOnce(
      mentorId,
    );

    if (ratings.isEmpty) {
      return {
        'averageRating': 0.0,
        'reviewCount': 0,
      };
    }

    double total = 0;

    for (final rating in ratings) {
      total += rating.rating;
    }

    final average =
        total / ratings.length;

    return {
      'averageRating': average,
      'reviewCount': ratings.length,
    };
  }

  // ================= GET RATING BY APPOINTMENT =================

  Future<RatingModel?> getRatingByAppointment(
    String appointmentId,
  ) async {
    final snapshot = await _firestore
        .collection('ratings')
        .where(
          'appointmentId',
          isEqualTo: appointmentId,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc =
        snapshot.docs.first;

    return RatingModel.fromMap(
      doc.id,
      doc.data(),
    );
  }

  // ================= CHECK HAS RATED =================

  Future<bool> hasRated({
    required String appointmentId,
    required String menteeId,
  }) async {
    final snapshot = await _firestore
        .collection('ratings')
        .where(
          'appointmentId',
          isEqualTo: appointmentId,
        )
        .where(
          'menteeId',
          isEqualTo: menteeId,
        )
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // ================= DELETE RATING =================

  Future<void> deleteRating(
    String ratingId,
  ) async {
    await _firestore
        .collection('ratings')
        .doc(ratingId)
        .delete();
  }
}