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
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepGreen.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(Icons.home, "Home", 0),
          _item(Icons.search, "Search", 1),
          _item(Icons.schedule, "Schedule", 2),
          _item(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, int index) {
    final bool active = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: active ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: active
              ? AppColors.mintGreen.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: active ? 1.05 : 1.0,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  size: active ? 26 : 24,
                  color: active ? AppColors.mintGreen : AppColors.gray,
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: active
                    ? Row(
                        children: [
                          const SizedBox(width: 6),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mintGreen,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}