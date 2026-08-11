  import 'package:cloud_firestore/cloud_firestore.dart';

  import '../models/notification_model.dart';

  class NotificationService {
    final FirebaseFirestore _firestore =
        FirebaseFirestore.instance;

    // =========================================================
    // CREATE NOTIFICATION
    // Gửi thông báo cho 1 user
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

      final notificationRef =
          _firestore.collection('notifications').doc();

      final notification = NotificationModel(
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
    // Lấy danh sách thông báo của user
    // =========================================================

    Stream<List<NotificationModel>> getUserNotifications(
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
                    (doc) => NotificationModel.fromMap(
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
    // Đếm số thông báo chưa đọc
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
            (snapshot) => snapshot.docs.length,
          );
    }

    // =========================================================
    // MARK AS READ
    // Đánh dấu 1 thông báo đã đọc
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
    // Đánh dấu tất cả thông báo của user đã đọc
    // =========================================================

    Future<void> markAllAsRead(
      String userId,
    ) async {
      final snapshot = await _firestore
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

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
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
    // Xóa 1 thông báo
    // =========================================================

    Future<void> deleteNotification(
      String notificationId,
    ) async {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .delete();
    }

    // =========================================================
    // SEND TO ALL USERS
    // Admin gửi thông báo cho tất cả user
    // =========================================================

    Future<void> sendToAllUsers({
      required String title,
      required String message,
      required String type,
    }) async {
      final snapshot =
          await _firestore.collection('users').get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      final batch = _firestore.batch();

      for (final userDoc in snapshot.docs) {
        final userId = userDoc.id;

        if (userId.trim().isEmpty) {
          continue;
        }

        final notificationRef =
            _firestore.collection('notifications').doc();

        final notification = NotificationModel(
          id: notificationRef.id,
          userId: userId,
          title: title,
          message: message,
          type: type,
          relatedId: null,
          isRead: false,
          createdAt: DateTime.now(),
        );

        batch.set(
          notificationRef,
          notification.toMap(),
        );
      }

      await batch.commit();
    }

    // =========================================================
    // SEND TO ROLE
    // Admin gửi thông báo theo role
    //
    // role:
    // - mentor
    // - mentee
    // =========================================================

    Future<void> sendToRole({
      required String role,
      required String title,
      required String message,
      required String type,
    }) async {
      final snapshot = await _firestore
          .collection('users')
          .where(
            'role',
            isEqualTo: role,
          )
          .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      final batch = _firestore.batch();

      for (final userDoc in snapshot.docs) {
        final userId = userDoc.id;

        if (userId.trim().isEmpty) {
          continue;
        }

        final notificationRef =
            _firestore.collection('notifications').doc();

        final notification = NotificationModel(
          id: notificationRef.id,
          userId: userId,
          title: title,
          message: message,
          type: type,
          relatedId: null,
          isRead: false,
          createdAt: DateTime.now(),
        );

        batch.set(
          notificationRef,
          notification.toMap(),
        );
      }

      await batch.commit();
    }

    // =========================================================
    // SEND TO SELECTED TARGET
    //
    // target:
    // - all
    // - mentor
    // - mentee
    //
    // Dùng trực tiếp cho AdminNotificationTab
    // =========================================================

    Future<void> sendAdminNotification({
      required String target,
      required String title,
      required String message,
    }) async {
      final cleanTarget =
          target.trim().toLowerCase();

      final cleanTitle = title.trim();
      final cleanMessage = message.trim();

      if (cleanTitle.isEmpty ||
          cleanMessage.isEmpty) {
        return;
      }

      switch (cleanTarget) {
        case 'all':
          await sendToAllUsers(
            title: cleanTitle,
            message: cleanMessage,
            type: 'admin',
          );
          break;

        case 'mentor':
          await sendToRole(
            role: 'mentor',
            title: cleanTitle,
            message: cleanMessage,
            type: 'admin',
          );
          break;

        case 'mentee':
          await sendToRole(
            role: 'mentee',
            title: cleanTitle,
            message: cleanMessage,
            type: 'admin',
          );
          break;

        default:
          throw ArgumentError(
            'Đối tượng nhận không hợp lệ: $target',
          );
      }
    }
  }