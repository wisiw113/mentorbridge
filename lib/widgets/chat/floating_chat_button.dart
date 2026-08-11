import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class FloatingChatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int unreadCount;

  const FloatingChatButton({
    super.key,
    required this.onPressed,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // =====================================================
        // CHAT BUTTON
        // =====================================================

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),

            // VIỀN ĐEN
            border: Border.all(
              color: Colors.black,
              width: 1.2,
            ),

            // SHADOW
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(14),
              child: const Center(
                child: Icon(
                  Icons.chat_bubble_rounded,
                  color: AppColors.deepGreen,
                  size: 26,
                ),
              ),
            ),
          ),
        ),

        // =====================================================
        // UNREAD BADGE
        // =====================================================

        if (unreadCount > 0)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(20),

                // VIỀN TRẮNG
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                unreadCount > 99
                    ? '99+'
                    : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}