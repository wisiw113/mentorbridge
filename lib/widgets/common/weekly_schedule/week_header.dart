import 'package:flutter/material.dart';

import '/../../core/theme/app_colors.dart';

class WeekHeader extends StatelessWidget {
  final VoidCallback? onViewAll;

  const WeekHeader({
    super.key,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 12,
        top: 12,
        bottom: 8,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.deepGreen,
            size: 24,
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: Text(
              "Thời khóa biểu tuần",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),
          ),

          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onViewAll,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: AppColors.deepGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}