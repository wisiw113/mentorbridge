import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.onPrevious,
    required this.onNext,
  });

  String get monthText {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return "${months[currentMonth.month - 1]} ${currentMonth.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _NavigationButton(
            icon: Icons.chevron_left_rounded,
            onPressed: onPrevious,
          ),

          Expanded(
            child: Center(
              child: Text(
                monthText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.calendarHeaderText,
                ),
              ),
            ),
          ),

          _NavigationButton(
            icon: Icons.chevron_right_rounded,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavigationButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: AppColors.calendarHeaderIcon,
            size: 24,
          ),
        ),
      ),
    );
  }
}