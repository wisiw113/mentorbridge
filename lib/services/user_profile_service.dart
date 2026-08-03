
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> updateProfile({
    required String uid,
    required String name,
    required int? birthYear,
    required String gender,
    required String bio,
  }) async {
    final newName = name.trim();

    if (newName.isEmpty) {
      throw Exception(
        'Tên không được để trống.',
      );
    }

    // =======================================================
    // FIRESTORE
    // =======================================================

    final userRef = _firestore
        .collection('users')
        .doc(uid);

    // =======================================================
    // 1. LẤY PROFILE HIỆN TẠI
    // =======================================================

    final userSnapshot =
        await userRef.get();

    if (!userSnapshot.exists) {
      throw Exception(
        'Không tìm thấy thông tin người dùng.',
      );
    }

    final userData =
        userSnapshot.data();

    if (userData == null) {
      throw Exception(
        'Dữ liệu người dùng không hợp lệ.',
      );
    }

    final oldName =
        userData['name']?.toString() ?? '';

    final role =
        userData['role']?.toString() ?? '';

    // =======================================================
    // 2. UPDATE USER PROFILE
    // =======================================================

    await userRef.set(
      {
        'name': newName,
        'birthYear': birthYear,
        'gender': gender,
        'bio': bio,
      },
      SetOptions(merge: true),
    );

    // =======================================================
    // 3. NẾU TÊN KHÔNG ĐỔI
    //
    // Không cần update các collection liên quan.
    // =======================================================

    if (oldName == newName) {
      return;
    }

    // =======================================================
    // 4. UPDATE RELATED DATA
    // =======================================================

    if (role == 'mentor') {
      await _syncMentorName(
        uid: uid,
        newName: newName,
      );
    }

    if (role == 'mentee') {
      await _syncMenteeName(
        uid: uid,
        newName: newName,
      );
    }
  }

  // =========================================================
  // SYNC MENTOR NAME
  // =========================================================

  Future<void> _syncMentorName({
    required String uid,
    required String newName,
  }) async {
    // =======================================================
    // APPOINTMENTS
    // =======================================================

    final appointments =
        await _firestore
            .collection('appointments')
            .where(
              'mentorId',
              isEqualTo: uid,
            )
            .get();

    // =======================================================
    // SESSIONS
    // =======================================================

    final sessions =
        await _firestore
            .collection('sessions')
            .where(
              'mentorId',
              isEqualTo: uid,
            )
            .get();

    // =======================================================
    // SESSION RATINGS
    // =======================================================

    final ratings =
        await _firestore
            .collection('session_ratings')
            .where(
              'mentorId',
              isEqualTo: uid,
            )
            .get();

    // =======================================================
    // BATCH
    // =======================================================

    final batch =
        _firestore.batch();

    // =======================================================
    // UPDATE APPOINTMENTS
    // =======================================================

    for (final doc
        in appointments.docs) {
      batch.update(
        doc.reference,
        {
          'mentorName': newName,
        },
      );
    }

    // =======================================================
    // UPDATE SESSIONS
    // =======================================================

    for (final doc
        in sessions.docs) {
      batch.update(
        doc.reference,
        {
          'mentorName': newName,
        },
      );
    }

    // =======================================================
    // UPDATE SESSION RATINGS
    // =======================================================

    for (final doc
        in ratings.docs) {
      batch.update(
        doc.reference,
        {
          'mentorName': newName,
        },
      );
    }

    // =======================================================
    // COMMIT
    // =======================================================

    if (appointments.docs.isNotEmpty ||
        sessions.docs.isNotEmpty ||
        ratings.docs.isNotEmpty) {
      await batch.commit();
    }
  }

  // =========================================================
  // SYNC MENTEE NAME
  // =========================================================

  Future<void> _syncMenteeName({
    required String uid,
    required String newName,
  }) async {
    // =======================================================
    // APPOINTMENTS
    // =======================================================

    final appointments =
        await _firestore
            .collection('appointments')
            .where(
              'menteeId',
              isEqualTo: uid,
            )
            .get();

    // =======================================================
    // SESSION PARTICIPANTS
    // =======================================================

    final participants =
        await _firestore
            .collection('session_participants')
            .where(
              'menteeId',
              isEqualTo: uid,
            )
            .get();

    // =======================================================
    // SESSION RATINGS
    // =======================================================

    final ratings =
        await _firestore
            .collection('session_ratings')
            .where(
              'menteeId',
              isEqualTo: uid,
            )
            .get();

    // =======================================================
    // BATCH
    // =======================================================

    final batch =
        _firestore.batch();

    // =======================================================
    // UPDATE APPOINTMENTS
    // =======================================================

    for (final doc
        in appointments.docs) {
      batch.update(
        doc.reference,
        {
          'menteeName': newName,
        },
      );
    }

    // =======================================================
    // UPDATE SESSION PARTICIPANTS
    // =======================================================

    for (final doc
        in participants.docs) {
      batch.update(
        doc.reference,
        {
          'menteeName': newName,
        },
      );
    }

    // =======================================================
    // UPDATE SESSION RATINGS
    // =======================================================

    for (final doc
        in ratings.docs) {
      batch.update(
        doc.reference,
        {
          'menteeName': newName,
        },
      );
    }

    // =======================================================
    // COMMIT
    // =======================================================

    if (appointments.docs.isNotEmpty ||
        participants.docs.isNotEmpty ||
        ratings.docs.isNotEmpty) {
      await batch.commit();
    }
  }

  // =========================================================
  // UPDATE PHOTO URL
  // =========================================================

  Future<void> updatePhotoURL({
    required String uid,
    required String photoURL,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(
      {
        'photoURL': photoURL,
      },
      SetOptions(merge: true),
    );
  }

  // =========================================================
  // GET USER PROFILE
  // =========================================================

  Future<Map<String, dynamic>?> getUserProfile(
    String uid,
  ) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) {
      return null;
    }

    return doc.data();
  }
}

