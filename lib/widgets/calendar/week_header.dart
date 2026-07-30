import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class WeekHeader extends StatelessWidget {
  const WeekHeader({super.key});

  static const List<String> _weekdays = [
    'CN',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Row(
        children: _weekdays
            .map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.calendarWeekText,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}