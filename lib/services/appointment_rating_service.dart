import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_rating_model.dart';

class AppointmentRatingService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String _collection =
      'appointmentRatings';

  // =========================================================
  // CREATE APPOINTMENT RATING
  // =========================================================

  Future<void> createRating(
    AppointmentRatingModel rating,
  ) async {
    // Kiểm tra Mentee đã đánh giá Appointment này chưa
    final existing = await _firestore
        .collection(_collection)
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
        .collection(_collection)
        .add(
      rating.toMap(),
    );
  }

  // =========================================================
  // GET RATING BY APPOINTMENT
  // =========================================================

  Future<AppointmentRatingModel?>
      getRatingByAppointment(
    String appointmentId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'appointmentId',
          isEqualTo: appointmentId,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return AppointmentRatingModel.fromMap(
      doc.id,
      doc.data(),
    );
  }

  // =========================================================
  // CHECK MENTEE HAS RATED APPOINTMENT
  // =========================================================

  Future<bool> hasRated({
    required String appointmentId,
    required String menteeId,
  }) async {
    final snapshot = await _firestore
        .collection(_collection)
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

  // =========================================================
  // GET ALL RATINGS OF MENTOR
  // =========================================================

  Stream<List<AppointmentRatingModel>>
      getMentorRatings(
    String mentorId,
  ) {
    return _firestore
        .collection(_collection)
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (doc) =>
                      AppointmentRatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();
          },
        );
  }

  // =========================================================
  // GET ALL RATINGS OF MENTOR - ONCE
  // =========================================================

  Future<List<AppointmentRatingModel>>
      getMentorRatingsOnce(
    String mentorId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              AppointmentRatingModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }

  // =========================================================
  // GET MENTOR AVERAGE RATING
  // =========================================================

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

  // =========================================================
  // GET MENTOR REVIEW COUNT
  // =========================================================

  Future<int> getMentorReviewCount(
    String mentorId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .get();

    return snapshot.docs.length;
  }

  // =========================================================
  // GET MENTOR RATING SUMMARY
  // =========================================================

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

  // =========================================================
  // GET ALL APPOINTMENT RATINGS
  // =========================================================

  Stream<List<AppointmentRatingModel>>
      getAllRatings() {
    return _firestore
        .collection(_collection)
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (doc) =>
                      AppointmentRatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();
          },
        );
  }

  // =========================================================
  // GET RATINGS BY MENTEE
  // =========================================================

  Stream<List<AppointmentRatingModel>>
      getMenteeRatings(
    String menteeId,
  ) {
    return _firestore
        .collection(_collection)
        .where(
          'menteeId',
          isEqualTo: menteeId,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (doc) =>
                      AppointmentRatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();
          },
        );
  }

  // =========================================================
  // UPDATE RATING
  // =========================================================

  Future<void> updateRating(
    AppointmentRatingModel rating,
  ) async {
    if (rating.id.isEmpty) {
      throw Exception(
        'Không thể cập nhật rating: rating ID không hợp lệ.',
      );
    }

    await _firestore
        .collection(_collection)
        .doc(rating.id)
        .update(
      rating.toMap(),
    );
  }

  // =========================================================
  // DELETE RATING
  // =========================================================

  Future<void> deleteRating(
    String ratingId,
  ) async {
    if (ratingId.isEmpty) {
      throw Exception(
        'Không thể xóa rating: rating ID không hợp lệ.',
      );
    }

    await _firestore
        .collection(_collection)
        .doc(ratingId)
        .delete();
  }
}