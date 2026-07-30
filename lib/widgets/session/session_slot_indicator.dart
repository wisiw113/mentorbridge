import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SessionSlotIndicator extends StatelessWidget {
  final int bookedSlots;
  final int maxSlots;

  const SessionSlotIndicator({
    super.key,
    required this.bookedSlots,
    required this.maxSlots,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        maxSlots == 0 ? 0 : bookedSlots / maxSlots;

    Color progressColor;

    if (progress >= 1) {
      progressColor = AppColors.error;
    } else if (progress >= 0.8) {
      progressColor = AppColors.warning;
    } else {
      progressColor = AppColors.mintGreen;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.groups_rounded,
              size: 18,
              color: AppColors.deepGreen,
            ),

            const SizedBox(width: 6),

            Expanded(
              child: Text(
                "$bookedSlots / $maxSlots participants",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
            ),

            Text(
              "${maxSlots - bookedSlots} left",
              style: TextStyle(
                color: progressColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(progressColor),
          ),
        ),
      ],
    );
  }
}