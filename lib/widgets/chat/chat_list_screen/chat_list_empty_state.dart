
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ChatListEmptyState extends StatelessWidget {
  const ChatListEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =================================================
            // ICON
            // =================================================

            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.softMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            // =================================================
            // TITLE
            // =================================================

            const Text(
              'Chưa có cuộc trò chuyện',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // =================================================
            // DESCRIPTION
            // =================================================

            const Text(
              'Các cuộc trò chuyện của bạn\n'
              'sẽ xuất hiện ở đây.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

