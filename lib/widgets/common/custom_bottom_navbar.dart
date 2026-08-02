import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class XBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const XBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),

              // Viền đen
              border: Border.all(
                color: Colors.black,
                width: 1.2,
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.deepGreen.withOpacity(0.10),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: "Home",
                index: 0,
              ),
              _item(
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: "Search",
                index: 1,
              ),
              _item(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: "Schedule",
                index: 2,
              ),
              _item(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: "Profile",
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool active = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: active ? 16 : 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: active
              ? AppColors.mintGreen.withOpacity(0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                active ? activeIcon : icon,
                key: ValueKey(active),
                size: active ? 25 : 24,
                color: active
                    ? AppColors.mintGreen
                    : AppColors.gray,
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: active
                  ? Row(
                      children: [
                        const SizedBox(width: 7),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mintGreen,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}