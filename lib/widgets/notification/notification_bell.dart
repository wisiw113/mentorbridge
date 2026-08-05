import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/notification_service.dart';

class NotificationBell
    extends StatelessWidget {
  final VoidCallback? onTap;

  const NotificationBell({
    super.key,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final user =
        FirebaseAuth.instance.currentUser;

    // =========================================================
    // CHƯA ĐĂNG NHẬP
    // =========================================================

    if (user == null) {
      return IconButton(
        onPressed: onTap,
        icon: const Icon(
          Icons.notifications_none_outlined,
        ),
        color: AppColors.deepGreen,
      );
    }

    // =========================================================
    // NOTIFICATION STREAM
    // =========================================================

    return StreamBuilder<int>(
      stream:
          NotificationService()
              .getUnreadCount(
        user.uid,
      ),
      builder: (
        context,
        snapshot,
      ) {
        final unreadCount =
            snapshot.data ?? 0;

        return Stack(
          clipBehavior:
              Clip.none,
          children: [
            // ===================================================
            // BELL
            // ===================================================

            IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons
                    .notifications_none_outlined,
              ),
              color:
                  AppColors.deepGreen,
            ),

            // ===================================================
            // BADGE
            // ===================================================

            if (unreadCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  constraints:
                      const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 4,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.error,
                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
                    ),
                    border:
                        Border.all(
                      color:
                          Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 99
                          ? '99+'
                          : unreadCount
                              .toString(),
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}