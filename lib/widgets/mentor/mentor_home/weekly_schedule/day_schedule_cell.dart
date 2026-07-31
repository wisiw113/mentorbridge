import 'package:flutter/material.dart';

import '/../../core/theme/app_colors.dart';
import '/models/schedule_item.dart';

class DayScheduleCell extends StatelessWidget {
  final String dayLabel;
  final ScheduleItem? item;
  final int extraCount;
  final bool isToday;
  final VoidCallback onTap;

  const DayScheduleCell({
    super.key,
    required this.dayLabel,
    required this.item,
    required this.extraCount,
    required this.onTap,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isToday ? AppColors.softMint : Colors.white;

    return SizedBox(
      width: 56,
      height: 140,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 140,
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.calendarShadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // =====================
              // THỨ
              // =====================

              Text(
                dayLabel,
                maxLines: 1,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepGreen,
                ),
              ),

              const SizedBox(height: 12),

              // =====================
              // KHÔNG CÓ LỊCH
              // =====================

              if (item == null) ...[
                const Icon(
                  Icons.event_available_outlined,
                  color: AppColors.gray,
                  size: 18,
                ),

                const SizedBox(height: 5),

                const Text(
                  'Trống',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.gray,
                  ),
                ),
              ]

              // =====================
              // CÓ LỊCH
              // =====================

              else ...[
                // Chỉ hiển thị giờ bắt đầu
                Text(
                  item!.startTime,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),

                // =====================
                // P = SESSION
                // A = APPOINTMENT
                // =====================

                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: item!.isSession
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.warning.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    item!.isSession ? 'P' : 'A',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: item!.isSession
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ),

                // =====================
                // CÓ THÊM LỊCH
                // =====================

                if (extraCount > 0) ...[
                  const SizedBox(height: 5),

                  Text(
                    '+$extraCount',
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepGreen,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}