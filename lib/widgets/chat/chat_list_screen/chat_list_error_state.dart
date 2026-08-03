
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ChatListErrorState extends StatelessWidget {
  final Object? error;

  const ChatListErrorState({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =================================================
            // ERROR ICON
            // =================================================

            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.error,
            ),

            const SizedBox(
              height: 12,
            ),

            // =================================================
            // TITLE
            // =================================================

            const Text(
              'Không thể tải tin nhắn',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // =================================================
            // ERROR MESSAGE
            // =================================================

            if (error != null)
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
