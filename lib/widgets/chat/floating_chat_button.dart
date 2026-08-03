  import 'package:flutter/material.dart';

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
          // =========================
          // FLOATING CHAT BUTTON
          // =========================
          Material(
            elevation: 5,
            shadowColor: Colors.black26,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),

          // =========================
          // UNREAD BADGE
          // =========================
          if (unreadCount > 0)
            Positioned(
              right: -2,
              top: -4,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: unreadCount > 9
                      ? BoxShape.rectangle
                      : BoxShape.circle,
                  borderRadius: unreadCount > 9
                      ? BorderRadius.circular(10)
                      : null,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
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
            ),
        ],
      );
    }
  }

