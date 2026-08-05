
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Vui lòng đăng nhập.',
          ),
        ),
      );
    }

    final notificationService =
        NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await notificationService
                    .markAllAsRead(user.uid);
              } catch (e) {
                debugPrint(
                  'MARK ALL READ ERROR: $e',
                );
              }
            },
            icon: const Icon(
              Icons.done_all,
            ),
          ),
        ],
      ),

      body: StreamBuilder<
          List<NotificationModel>>(
        stream: notificationService
            .getUserNotifications(
          user.uid,
        ),
        builder: (
          context,
          snapshot,
        ) {

          // =================================================
          // ERROR
          // =================================================

          if (snapshot.hasError) {
            debugPrint(
              'NOTIFICATION STREAM ERROR: '
              '${snapshot.error}',
            );

            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Text(
                  'Lỗi tải thông báo:\n\n'
                  '${snapshot.error}',
                  textAlign:
                      TextAlign.center,
                ),
              ),
            );
          }

          // =================================================
          // LOADING
          // =================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // =================================================
          // DATA
          // =================================================

          final notifications =
              snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có thông báo',
              ),
            );
          }

          return ListView.builder(
            itemCount:
                notifications.length,
            itemBuilder: (
              context,
              index,
            ) {
              final notification =
                  notifications[index];

              return ListTile(
                leading: Icon(
                  notification.isRead
                      ? Icons
                          .notifications_none
                      : Icons.notifications,
                ),

                title: Text(
                  notification.title,
                ),

                subtitle: Text(
                  notification.message,
                ),

                tileColor:
                    notification.isRead
                        ? null
                        : Colors.green
                            .withOpacity(0.08),

                onTap: () async {
                  if (!notification
                      .isRead) {
                    try {
                      await notificationService
                          .markAsRead(
                        notification.id,
                      );
                    } catch (e) {
                      debugPrint(
                        'MARK AS READ ERROR: $e',
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

