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
// Kiểm tra mentee đã đánh giá Session này chưa
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
// GET ALL RATINGS OF A SESSION
// =========================================================

Stream<List<SessionRatingModel>>
getSessionRatings(
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
return snapshot.docs
.map(
(doc) =>
SessionRatingModel.fromMap(
doc.id,
doc.data(),
),
)
.toList();
},
);
}

// =========================================================
// GET ALL RATINGS OF A MENTOR
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
return snapshot.docs
.map(
(doc) =>
SessionRatingModel.fromMap(
doc.id,
doc.data(),
),
)
.toList();
},
);
}

// =========================================================
// GET MENTOR SESSION RATINGS ONCE
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


return snapshot.docs
    .map(
      (doc) =>
          SessionRatingModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
    .toList();


}

// =========================================================
// GET MENTOR SESSION AVERAGE RATING
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
// DELETE SESSION RATING
// =========================================================

Future<void> deleteSessionRating(
String ratingId,
) async {
await _firestore
.collection(_collection)
.doc(ratingId)
.delete();
}
}
