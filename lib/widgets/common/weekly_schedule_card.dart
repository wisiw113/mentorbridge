import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/models/schedule_item.dart';
import 'weekly_schedule/week_day_row.dart';
import 'weekly_schedule/week_header.dart';

class WeeklyScheduleCard extends StatelessWidget {
  final List<ScheduleItem> schedules;

  final ValueChanged<DateTime>? onDayTap;

  final VoidCallback? onViewAll;

  const WeeklyScheduleCard({
    super.key,
    required this.schedules,
    this.onDayTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final weekDays = _buildWeekDays();

    final scheduleMap = _buildScheduleMap(weekDays);

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================
            // HEADER
            // ==========================

            WeekHeader(
              onViewAll: () {
                _showFullSchedule(
                  context,
                  weekDays,
                  scheduleMap,
                );
              },
            ),

            const SizedBox(height: 14),

            // ==========================
            // WEEK DAYS - GIỮ THANH CUỘN
            // ==========================

            SizedBox(
              height: 160,
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 4,
                radius: const Radius.circular(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: WeekDayRow(
                    weekDays: weekDays,
                    schedules: scheduleMap,
                    onDayTap: onDayTap ?? (_) {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // POPUP FULL LỊCH
  // ============================================================

  void _showFullSchedule(
    BuildContext context,
    List<DateTime> weekDays,
    Map<DateTime, List<ScheduleItem>> scheduleMap,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _FullScheduleSheet(
          weekDays: weekDays,
          schedules: scheduleMap,
          onDayTap: onDayTap,
        );
      },
    );
  }

  // ============================================================
  // TẠO 7 NGÀY TRONG TUẦN
  // ============================================================

  List<DateTime> _buildWeekDays() {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final monday = today.subtract(
      Duration(
        days: now.weekday - 1,
      ),
    );

    return List.generate(
      7,
      (index) => monday.add(
        Duration(days: index),
      ),
    );
  }

  // ============================================================
  // GOM LỊCH THEO NGÀY
  // ============================================================

  Map<DateTime, List<ScheduleItem>> _buildScheduleMap(
    List<DateTime> weekDays,
  ) {
    final map = <DateTime, List<ScheduleItem>>{};

    // Tạo danh sách rỗng cho 7 ngày
    for (final day in weekDays) {
      map[_normalize(day)] = [];
    }

    // Đưa schedule vào đúng ngày
    for (final item in schedules) {
      final date = _normalize(item.startAt);

      if (map.containsKey(date)) {
        map[date]!.add(item);
      }
    }

    // Sắp xếp theo giờ bắt đầu
    for (final items in map.values) {
      items.sort(
        (a, b) => a.startAt.compareTo(
          b.startAt,
        ),
      );
    }

    return map;
  }

  // ============================================================
  // CHUẨN HÓA NGÀY
  // ============================================================

  DateTime _normalize(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}

// =================================================================
// FULL SCHEDULE BOTTOM SHEET
// =================================================================

class _FullScheduleSheet extends StatelessWidget {
  final List<DateTime> weekDays;

  final Map<DateTime, List<ScheduleItem>> schedules;

  final ValueChanged<DateTime>? onDayTap;

  const _FullScheduleSheet({
    required this.weekDays,
    required this.schedules,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // ========================================================
          // HANDLE
          // ========================================================

          const SizedBox(height: 10),

          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // ========================================================
          // HEADER
          // ========================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              12,
              12,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.deepGreen,
                  size: 25,
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    'Thời khóa biểu tuần',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepGreen,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ========================================================
          // DANH SÁCH 7 NGÀY
          // ========================================================

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                24,
              ),
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                final day = weekDays[index];

                final date = DateTime(
                  day.year,
                  day.month,
                  day.day,
                );

                final items = schedules[date] ?? [];

                return _FullDaySchedule(
                  day: day,
                  items: items,
                  onTap: () {
                    onDayTap?.call(day);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// MỘT NGÀY TRONG POPUP
// =================================================================

class _FullDaySchedule extends StatelessWidget {
  final DateTime day;

  final List<ScheduleItem> items;

  final VoidCallback? onTap;

  const _FullDaySchedule({
    required this.day,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final isToday =
        day.year == now.year &&
        day.month == now.month &&
        day.day == now.day;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.softMint
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isToday
                  ? AppColors.deepGreen.withOpacity(0.25)
                  : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================================================
              // NGÀY
              // ====================================================

              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColors.deepGreen
                          : AppColors.softMint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _dayLabel(day.weekday),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? Colors.white
                            : AppColors.deepGreen,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(day),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (isToday)
                        const Text(
                          'Hôm nay',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.deepGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),

                  const Spacer(),

                  if (items.isNotEmpty)
                    Text(
                      '${items.length} lịch',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // ====================================================
              // KHÔNG CÓ LỊCH
              // ====================================================

              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event_available_outlined,
                        size: 20,
                        color: AppColors.gray,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Không có lịch',
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )

              // ====================================================
              // CÓ LỊCH
              // ====================================================

              else
                Column(
                  children: items.map(
                    (item) {
                      return _ScheduleDetailItem(
                        item: item,
                      );
                    },
                  ).toList(),
                ),
            ],
          ),
        ),
      ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// =================================================================
// CHI TIẾT MỘT LỊCH
// =================================================================

class _ScheduleDetailItem extends StatelessWidget {
  final ScheduleItem item;

  const _ScheduleDetailItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSession = item.isSession;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // ========================================================
          // GIỜ
          // ========================================================

          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.startTime,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  item.endTime,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ========================================================
          // A / P
          // ========================================================

          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSession
                  ? AppColors.success.withOpacity(0.15)
                  : AppColors.warning.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              isSession ? 'P' : 'A',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSession
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ========================================================
          // TÊN
          // ========================================================

          Expanded(
            child: Text(
              isSession
                  ? 'Session'
                  : 'Appointment',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}