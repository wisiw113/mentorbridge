import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =========================================================
  // CREATE NOTIFICATION
  // =========================================================

  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
  }) async {
    if (userId.trim().isEmpty) {
      return;
    }

    final notificationRef = _firestore
        .collection('notifications')
        .doc();

    final notification =
        NotificationModel(
      id: notificationRef.id,
      userId: userId,
      title: title,
      message: message,
      type: type,
      relatedId: relatedId,
      isRead: false,
      createdAt: DateTime.now(),
    );

    await notificationRef.set(
      notification.toMap(),
    );
  }

  // =========================================================
  // GET USER NOTIFICATIONS
  // =========================================================

  Stream<List<NotificationModel>>
      getUserNotifications(
    String userId,
  ) {
    return _firestore
        .collection('notifications')
        .where(
          'userId',
          isEqualTo: userId,
        )
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
                  NotificationModel.fromMap(
                doc.id,
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  // =========================================================
  // GET UNREAD COUNT
  // =========================================================

  Stream<int> getUnreadCount(
    String userId,
  ) {
    return _firestore
        .collection('notifications')
        .where(
          'userId',
          isEqualTo: userId,
        )
        .where(
          'isRead',
          isEqualTo: false,
        )
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.length,
        );
  }

  // =========================================================
  // MARK AS READ
  // =========================================================

  Future<void> markAsRead(
    String notificationId,
  ) async {
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({
      'isRead': true,
    });
  }

  // =========================================================
  // MARK ALL AS READ
  // =========================================================

  Future<void> markAllAsRead(
    String userId,
  ) async {
    final snapshot =
        await _firestore
            .collection('notifications')
            .where(
              'userId',
              isEqualTo: userId,
            )
            .where(
              'isRead',
              isEqualTo: false,
            )
            .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final batch =
        _firestore.batch();

    for (final doc
        in snapshot.docs) {
      batch.update(
        doc.reference,
        {
          'isRead': true,
        },
      );
    }

    await batch.commit();
  }

  // =========================================================
  // DELETE NOTIFICATION
  // =========================================================

  Future<void> deleteNotification(
    String notificationId,
  ) async {
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}