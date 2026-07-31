import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/session_rating_model.dart';

class SessionRatingService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String _collection =
      'session_ratings';

  // =========================================================
  // CREATE SESSION RATING
  // =========================================================

  Future<void> createSessionRating(
    SessionRatingModel rating,
  ) async {
    // Kiểm tra Mentee đã đánh giá Session này chưa
    final existing = await _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: rating.sessionId,
        )
        .where(
          'menteeId',
          isEqualTo: rating.menteeId,
        )
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception(
        'Bạn đã đánh giá Session này rồi.',
      );
    }

    // Tạo rating
    await _firestore
        .collection(_collection)
        .add(
      rating.toMap(),
    );
  }

  // =========================================================
  // GET ALL RATINGS OF A SESSION - REALTIME
  // =========================================================

  Stream<List<SessionRatingModel>> getSessionRatings(
    String sessionId,
  ) {
    return _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .snapshots()
        .map(
          (snapshot) {
            final ratings = snapshot.docs
                .map(
                  (doc) =>
                      SessionRatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();

            // Rating mới nhất lên trước
            ratings.sort(
              (a, b) =>
                  b.createdAt.compareTo(
                a.createdAt,
              ),
            );

            return ratings;
          },
        );
  }

  // =========================================================
  // GET ALL RATINGS OF A SESSION - ONCE
  // =========================================================

  Future<List<SessionRatingModel>>
      getSessionRatingsOnce(
    String sessionId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .get();

    final ratings = snapshot.docs
        .map(
          (doc) =>
              SessionRatingModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();

    ratings.sort(
      (a, b) =>
          b.createdAt.compareTo(
        a.createdAt,
      ),
    );

    return ratings;
  }

  // =========================================================
  // GET SESSION AVERAGE RATING
  // =========================================================

  Future<double> getSessionAverageRating(
    String sessionId,
  ) async {
    final ratings =
        await getSessionRatingsOnce(
      sessionId,
    );

    if (ratings.isEmpty) {
      return 0.0;
    }

    double total = 0.0;

    for (final rating in ratings) {
      total += rating.rating;
    }

    return total / ratings.length;
  }

  // =========================================================
  // GET SESSION REVIEW COUNT
  // =========================================================

  Future<int> getSessionReviewCount(
    String sessionId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .get();

    return snapshot.docs.length;
  }

  // =========================================================
  // GET SESSION RATING SUMMARY
  //
  // Dùng cho SessionCard
  //
  // Kết quả:
  //
  // {
  //   "averageRating": 4.5,
  //   "reviewCount": 10
  // }
  //
  // =========================================================

  Future<Map<String, dynamic>>
      getSessionRatingSummary(
    String sessionId,
  ) async {
    final ratings =
        await getSessionRatingsOnce(
      sessionId,
    );

    if (ratings.isEmpty) {
      return {
        'averageRating': 0.0,
        'reviewCount': 0,
      };
    }

    double total = 0.0;

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
  // GET SESSION RATING SUMMARY - REALTIME
  //
  // Dùng khi muốn Session Detail cập nhật
  // rating ngay sau khi Mentee đánh giá.
  // =========================================================

  Stream<Map<String, dynamic>>
      getSessionRatingSummaryStream(
    String sessionId,
  ) {
    return _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .snapshots()
        .map(
          (snapshot) {
            if (snapshot.docs.isEmpty) {
              return {
                'averageRating': 0.0,
                'reviewCount': 0,
              };
            }

            double total = 0.0;

            for (final doc in snapshot.docs) {
              final data = doc.data();

              final rating =
                  data['rating'];

              if (rating is num) {
                total +=
                    rating.toDouble();
              }
            }

            return {
              'averageRating':
                  total /
                      snapshot.docs.length,
              'reviewCount':
                  snapshot.docs.length,
            };
          },
        );
  }

  // =========================================================
  // GET ALL RATINGS OF A MENTOR - REALTIME
  // =========================================================

  Stream<List<SessionRatingModel>>
      getMentorSessionRatings(
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
            final ratings = snapshot.docs
                .map(
                  (doc) =>
                      SessionRatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();

            ratings.sort(
              (a, b) =>
                  b.createdAt.compareTo(
                a.createdAt,
              ),
            );

            return ratings;
          },
        );
  }

  // =========================================================
  // GET ALL RATINGS OF A MENTOR - ONCE
  // =========================================================

  Future<List<SessionRatingModel>>
      getMentorSessionRatingsOnce(
    String mentorId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .get();

    final ratings = snapshot.docs
        .map(
          (doc) =>
              SessionRatingModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();

    ratings.sort(
      (a, b) =>
          b.createdAt.compareTo(
        a.createdAt,
      ),
    );

    return ratings;
  }

  // =========================================================
  // GET MENTOR SESSION AVERAGE RATING
  //
  // Tính trung bình tất cả Session của Mentor
  // =========================================================

  Future<double>
      getMentorSessionAverageRating(
    String mentorId,
  ) async {
    final ratings =
        await getMentorSessionRatingsOnce(
      mentorId,
    );

    if (ratings.isEmpty) {
      return 0.0;
    }

    double total = 0.0;

    for (final rating in ratings) {
      total += rating.rating;
    }

    return total / ratings.length;
  }

  // =========================================================
  // GET MENTOR SESSION REVIEW COUNT
  // =========================================================

  Future<int>
      getMentorSessionReviewCount(
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
  // GET MENTOR SESSION RATING SUMMARY
  //
  // Dùng cho:
  // SessionRatingSummaryCard
  //
  // Hiển thị tổng rating của Mentor
  // trên tất cả Session.
  // =========================================================

  Future<Map<String, dynamic>>
      getMentorSessionRatingSummary(
    String mentorId,
  ) async {
    final ratings =
        await getMentorSessionRatingsOnce(
      mentorId,
    );

    if (ratings.isEmpty) {
      return {
        'averageRating': 0.0,
        'reviewCount': 0,
      };
    }

    double total = 0.0;

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
  // GET RATING BY SESSION
  //
  // Lấy một rating đầu tiên của Session.
  //
  // Lưu ý:
  // Hàm này chỉ nên dùng để kiểm tra Session
  // có rating hay không.
  //
  // Nếu muốn lấy tất cả review:
  // dùng getSessionRatings()
  // =========================================================

  Future<SessionRatingModel?>
      getRatingBySession(
    String sessionId,
  ) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc =
        snapshot.docs.first;

    return SessionRatingModel.fromMap(
      doc.id,
      doc.data(),
    );
  }

  // =========================================================
  // GET RATING BY ID
  // =========================================================

  Future<SessionRatingModel?>
      getRatingById(
    String ratingId,
  ) async {
    if (ratingId.isEmpty) {
      return null;
    }

    final doc = await _firestore
        .collection(_collection)
        .doc(ratingId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return SessionRatingModel.fromMap(
      doc.id,
      doc.data() ?? {},
    );
  }

  // =========================================================
  // CHECK HAS RATED SESSION
  // =========================================================

  Future<bool> hasRatedSession({
    required String sessionId,
    required String menteeId,
  }) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: sessionId,
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
  // GET RATING BY SESSION + MENTEE
  //
  // Dùng để lấy rating mà một Mentee
  // đã đánh giá cho một Session.
  // =========================================================

  Future<SessionRatingModel?>
      getRatingBySessionAndMentee({
    required String sessionId,
    required String menteeId,
  }) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .where(
          'menteeId',
          isEqualTo: menteeId,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc =
        snapshot.docs.first;

    return SessionRatingModel.fromMap(
      doc.id,
      doc.data(),
    );
  }

  // =========================================================
  // GET ALL RATINGS
  // =========================================================

  Stream<List<SessionRatingModel>>
      getAllRatings() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) {
            final ratings = snapshot.docs
                .map(
                  (doc) =>
                      SessionRatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();

            ratings.sort(
              (a, b) =>
                  b.createdAt.compareTo(
                a.createdAt,
              ),
            );

            return ratings;
          },
        );
  }

  // =========================================================
  // GET RATINGS BY MENTEE
  // =========================================================

  Stream<List<SessionRatingModel>>
      getMenteeSessionRatings(
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
            final ratings = snapshot.docs
                .map(
                  (doc) =>
                      SessionRatingModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();

            ratings.sort(
              (a, b) =>
                  b.createdAt.compareTo(
                a.createdAt,
              ),
            );

            return ratings;
          },
        );
  }

  // =========================================================
  // UPDATE SESSION RATING
  // =========================================================

  Future<void> updateSessionRating(
    SessionRatingModel rating,
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
  // DELETE SESSION RATING
  // =========================================================

  Future<void> deleteSessionRating(
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

