import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class NotificationEmptyState
    extends StatelessWidget {
  const NotificationEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 16),

            const Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "You don't have any notifications yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}