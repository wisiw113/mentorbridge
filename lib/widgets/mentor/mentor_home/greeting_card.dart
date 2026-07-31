import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class GreetingCard extends StatelessWidget {
  final String mentorName;

  const GreetingCard({
    super.key,
    required this.mentorName,
  });

  @override
  Widget build(BuildContext context) {
    final greeting = _greeting;
    final icon = _icon;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softMint,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deepGreen,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  mentorName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Chúc bạn có một ngày làm việc hiệu quả và nhiều cảm hứng!",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 36,
              color: AppColors.deepGreen,
            ),
          ),
        ],
      ),
    );
  }

  int get _hour => DateTime.now().hour;

  String get _greeting {
    if (_hour < 12) {
      return "🌤 Chào buổi sáng,";
    }

    if (_hour < 18) {
      return "☀️ Chào buổi chiều,";
    }

    return "🌙 Chào buổi tối,";
  }

  IconData get _icon {
    if (_hour < 12) {
      return Icons.wb_sunny_rounded;
    }

    if (_hour < 18) {
      return Icons.light_mode_rounded;
    }

    return Icons.nightlight_round;
  }
}