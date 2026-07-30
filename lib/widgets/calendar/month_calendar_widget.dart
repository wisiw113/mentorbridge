import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'calendar_header.dart';
import 'week_header.dart';

class MonthCalendarWidget extends StatefulWidget {
  final DateTime initialMonth;
  final List<DateTime> bookedDates;
  final ValueChanged<DateTime>? onDateSelected;

  const MonthCalendarWidget({
    super.key,
    required this.initialMonth,
    required this.bookedDates,
    this.onDateSelected,
  });

  @override
  State<MonthCalendarWidget> createState() =>
      _MonthCalendarWidgetState();
}

class _MonthCalendarWidgetState
    extends State<MonthCalendarWidget> {
  late DateTime currentMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    currentMonth = DateTime(
      widget.initialMonth.year,
      widget.initialMonth.month,
    );
  }

  // =========================
  // DATE HELPERS
  // =========================

  DateTime normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool isToday(DateTime date) {
    return isSameDay(
      date,
      DateTime.now(),
    );
  }

  bool hasBooking(DateTime date) {
    final target = normalize(date);

    return widget.bookedDates.any(
      (bookedDate) =>
          isSameDay(normalize(bookedDate), target),
    );
  }

  // =========================
  // CALENDAR
  // =========================

  List<DateTime> getDaysInMonth(
    DateTime month,
  ) {
    final lastDay = DateTime(
      month.year,
      month.month + 1,
      0,
    );

    return List.generate(
      lastDay.day,
      (index) => DateTime(
        month.year,
        month.month,
        index + 1,
      ),
    );
  }

  int getWeekdayOffset(
    DateTime month,
  ) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    return firstDay.weekday % 7;
  }

  // =========================
  // MONTH NAVIGATION
  // =========================

  void goToPreviousMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month - 1,
      );
    });
  }

  void goToNextMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
      );
    });
  }

  // =========================
  // SELECT DATE
  // =========================

  void selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });

    widget.onDateSelected?.call(date);
  }
  @override
Widget build(BuildContext context) {
  final days = getDaysInMonth(currentMonth);
  final offset = getWeekdayOffset(currentMonth);
  final totalCells = days.length + offset;

  return LayoutBuilder(
    builder: (context, constraints) {
      const horizontalPadding = 8.0;
      const spacing = 6.0;

      final availableWidth =
          constraints.maxWidth - (horizontalPadding * 2);

      final cellSize =
          (availableWidth - spacing * 6) / 7;

      final rows = (totalCells / 7).ceil();

      final gridHeight =
          rows * cellSize + (rows - 1) * spacing;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarHeader(
            currentMonth: currentMonth,
            onPrevious: goToPreviousMonth,
            onNext: goToNextMonth,
          ),

          const SizedBox(height: 8),

          const WeekHeader(),

          const SizedBox(height: 8),

          SizedBox(
            height: gridHeight,
            child: GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              itemCount: totalCells,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                if (index < offset) {
                  return const SizedBox();
                }

                final date = days[index - offset];

                final today = isToday(date);
                final booked = hasBooking(date);

                final selected =
                    selectedDate != null &&
                        isSameDay(
                          date,
                          selectedDate!,
                        );

                return GestureDetector(
                  onTap: () => selectDate(date),
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 180,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors
                              .calendarSelectedBackground
                          : today
                              ? AppColors
                                  .calendarTodayBackground
                              : booked
                                  ? AppColors
                                      .calendarBookedBackground
                                  : AppColors
                                      .calendarDayBackground,

                      borderRadius:
                          BorderRadius.circular(14),

                      border: Border.all(
                        color: today
                            ? AppColors
                                .calendarTodayBorder
                            : AppColors
                                .calendarDayBorder,
                      ),

                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors
                                    .calendarShadow,
                                blurRadius: 8,
                                offset:
                                    const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w600,
                            color: selected
                                ? AppColors
                                    .calendarSelectedText
                                : today
                                    ? AppColors
                                        .calendarTodayText
                                    : AppColors
                                        .calendarDayText,
                          ),
                        ),

                        const SizedBox(height: 4),

                        if (booked)
                          Container(
                            width: 6,
                            height: 6,
                            decoration:
                                const BoxDecoration(
                              color: AppColors
                                  .calendarBookingDot,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
}