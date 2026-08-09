import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

import '../../widgets/notification/notification_empty_state.dart';
import '../../widgets/notification/notification_list.dart';

import 'notification_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Please login first.",
          ),
        ),
      );
    }

    final notificationService =
        NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
        ),
        actions: [
          IconButton(
            tooltip: "Mark all as read",
            icon: const Icon(
              Icons.done_all_rounded,
            ),
            onPressed: () async {
              try {
                await notificationService
                    .markAllAsRead(
                  user.uid,
                );
              } catch (e) {
                debugPrint(
                  "MARK ALL READ ERROR: $e",
                );
              }
            },
          ),
        ],
      ),

      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService
            .getUserNotifications(
          user.uid,
        ),
        builder: (
          context,
          snapshot,
        ) {
          // ===========================
          // ERROR
          // ===========================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Text(
                  "Error loading notifications\n\n${snapshot.error}",
                  textAlign:
                      TextAlign.center,
                ),
              ),
            );
          }

          // ===========================
          // LOADING
          // ===========================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // ===========================
          // DATA
          // ===========================

          final notifications =
              snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const NotificationEmptyState();
          }

          return NotificationList(
            notifications: notifications,
            onTap: (
              NotificationModel notification,
            ) async {
              if (!notification.isRead) {
                try {
                  await notificationService
                      .markAsRead(
                    notification.id,
                  );
                } catch (e) {
                  debugPrint(
                    "MARK READ ERROR: $e",
                  );
                }
              }

              if (!context.mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NotificationDetailScreen(
                    notification:
                        notification,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}