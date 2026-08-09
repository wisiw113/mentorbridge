import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import 'notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationModel>
      notifications;

  final Function(
    NotificationModel notification,
  ) onTap;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (
        context,
        index,
      ) {
        final notification =
            notifications[index];

        return NotificationCard(
          notification: notification,
          onTap: () =>
              onTap(notification),
        );
      },
    );
  }
}