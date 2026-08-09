import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case "appointment":
        return Icons.calendar_month_rounded;

      case "session":
        return Icons.groups_rounded;

      case "chat":
        return Icons.chat_bubble_rounded;

      case "rating":
        return Icons.star_rounded;

      default:
        return Icons.notifications_rounded;
    }
  }

  String _getTypeName() {
    switch (notification.type) {
      case "appointment":
        return "Appointment";

      case "session":
        return "Session";

      case "chat":
        return "Chat";

      case "rating":
        return "Rating";

      default:
        return "Notification";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),

      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        foregroundColor: Colors.white,
        title: const Text(
          "Notification",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //==================================================
            // ICON
            //==================================================

            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.softMint.withOpacity(.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                size: 46,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 20),

            //==================================================
            // TITLE
            //==================================================

            Text(
              notification.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            //==================================================
            // DETAIL CARD
            //==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildRow(
                    "Type",
                    _getTypeName(),
                  ),

                  const Divider(),

                  _buildRow(
                    "Status",
                    notification.isRead
                        ? "Read"
                        : "Unread",
                  ),

                  const Divider(),

                  _buildRow(
                    "Time",
                    notification.createdAt
                        .toString(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //==================================================
            // MESSAGE
            //==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Message",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.gray,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}