import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/notification_service.dart';

class NotificationBell extends StatelessWidget {
  final VoidCallback? onTap;

  const NotificationBell({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // =========================================================
    // USER CHƯA ĐĂNG NHẬP
    // =========================================================

    if (user == null) {
      return _buildBell(
        unreadCount: 0,
      );
    }

    // =========================================================
    // USER ĐÃ ĐĂNG NHẬP
    // =========================================================

    return StreamBuilder<int>(
      stream: NotificationService().getUnreadCount(
        user.uid,
      ),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;

        return _buildBell(
          unreadCount: unreadCount,
        );
      },
    );
  }

  // =========================================================
  // BUILD BELL
  // =========================================================

  Widget _buildBell({
    required int unreadCount,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // =====================================================
        // NOTIFICATION BUTTON
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
            child: IconButton(
              tooltip: 'Notifications',
              splashRadius: 22,
              onPressed: onTap,
              icon: const Icon(
                Icons.notifications_rounded,
                size: 26,
              ),
              color: AppColors.deepGreen,
            ),
          ),
        ),

        // =====================================================
        // UNREAD BADGE
        // =====================================================

        Positioned(
          right: -3,
          top: -3,
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 220,
            ),
            transitionBuilder: (
              child,
              animation,
            ) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: unreadCount == 0
                ? const SizedBox.shrink()
                : Container(
                    key: ValueKey(
                      unreadCount,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius:
                          BorderRadius.circular(20),

                      // VIỀN TRẮNG CHO BADGE
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
        ),
      ],
    );
  }
}