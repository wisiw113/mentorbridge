import 'package:flutter/material.dart';

import '/models/schedule_item.dart';
import 'day_schedule_cell.dart';

class WeekDayRow extends StatelessWidget {
  final List<DateTime> weekDays;
  final Map<DateTime, List<ScheduleItem>> schedules;
  final ValueChanged<DateTime> onDayTap;

  const WeekDayRow({
    super.key,
    required this.weekDays,
    required this.schedules,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weekDays.map((day) {
        final date = DateTime(
          day.year,
          day.month,
          day.day,
        );

        final items = schedules[date] ?? [];

        final isToday =
            day.year == now.year &&
            day.month == now.month &&
            day.day == now.day;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
          ),
          child: DayScheduleCell(
            dayLabel: _dayLabel(day.weekday),
            item: items.isNotEmpty ? items.first : null,
            extraCount:
                items.length > 1 ? items.length - 1 : 0,
            isToday: isToday,
            onTap: () => onDayTap(day),
          ),
        );
      }).toList(),
    );
  }

  String _dayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'T2';
      case DateTime.tuesday:
        return 'T3';
      case DateTime.wednesday:
        return 'T4';
      case DateTime.thursday:
        return 'T5';
      case DateTime.friday:
        return 'T6';
      case DateTime.saturday:
        return 'T7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }
}