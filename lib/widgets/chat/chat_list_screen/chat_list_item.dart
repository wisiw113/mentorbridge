
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/chat_model.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final bool isMentor;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.isMentor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // =======================================================
    // OTHER USER
    // =======================================================

    final String title = isMentor
        ? chat.menteeName
        : chat.mentorName;

    final String initial = title.trim().isEmpty
        ? '?'
        : title.trim().substring(0, 1).toUpperCase();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        // =====================================================
        // AVATAR
        // =====================================================

        leading: CircleAvatar(
          radius: 27,
          backgroundColor: AppColors.softMint,

          child: Text(
            initial,
            style: const TextStyle(
              color: AppColors.deepGreen,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // =====================================================
        // NAME
        // =====================================================

        title: Text(
          title.isEmpty ? 'Người dùng' : title,

          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),

        // =====================================================
        // LAST MESSAGE
        // =====================================================

        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 5,
          ),

          child: Text(
            chat.lastMessage.isEmpty
                ? 'Bắt đầu cuộc trò chuyện'
                : chat.lastMessage,

            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 13,
              color: chat.lastMessage.isEmpty
                  ? AppColors.gray
                  : AppColors.deepGreen,
            ),
          ),
        ),

        // =====================================================
        // TIME
        // =====================================================

        trailing: Text(
          _formatTime(chat.lastMessageAt),

          style: const TextStyle(
            fontSize: 11,
            color: AppColors.gray,
          ),
        ),

        // =====================================================
        // OPEN CHAT
        // =====================================================

        onTap: onTap,
      ),
    );
  }

  // =========================================================
  // FORMAT TIME
  // =========================================================

  String _formatTime(DateTime time) {
    final now = DateTime.now();

    // TODAY
    final isToday =
        now.year == time.year &&
        now.month == time.month &&
        now.day == time.day;

    if (isToday) {
      return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    }

    // YESTERDAY
    final yesterday = now.subtract(
      const Duration(days: 1),
    );

    final isYesterday =
        yesterday.year == time.year &&
        yesterday.month == time.month &&
        yesterday.day == time.day;

    if (isYesterday) {
      return 'Hôm qua';
    }

    // THIS YEAR
    if (now.year == time.year) {
      return '${time.day}/${time.month}';
    }

    // DIFFERENT YEAR
    return '${time.day}/${time.month}/${time.year}';
  }
}
