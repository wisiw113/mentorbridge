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

    if (user == null) {
      return IconButton(
        onPressed: onTap,
        icon: const Icon(
          Icons.notifications_rounded,
        ),
        color: AppColors.deepGreen,
      );
    }

    return StreamBuilder<int>(
      stream: NotificationService().getUnreadCount(
        user.uid,
      ),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Colors.transparent,
              child: IconButton(
                tooltip: "Notifications",
                splashRadius: 22,
                onPressed: onTap,
                icon: const Icon(
                  Icons.notifications_rounded,
                  size: 28,
                ),
                color: AppColors.deepGreen,
              ),
            ),

            Positioned(
              right: 4,
              top: 4,
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 220,
                ),
                transitionBuilder:
                    (child, animation) =>
                        ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: unreadCount == 0
                    ? const SizedBox.shrink()
                    : Container(
                        key: ValueKey(
                          unreadCount,
                        ),
                        constraints:
                            const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color:
                                  Colors.black12,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        alignment:
                            Alignment.center,
                        child: Text(
                          unreadCount > 99
                              ? "99+"
                              : unreadCount
                                  .toString(),
                          style:
                              const TextStyle(
                            color: Colors.white,
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