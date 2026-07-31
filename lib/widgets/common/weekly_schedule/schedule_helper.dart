import 'package:flutter/material.dart';

import '/../../core/theme/app_colors.dart';
import '/models/schedule_item.dart';

class DayScheduleCell extends StatelessWidget {
  final String dayLabel;
  final ScheduleItem? item;

  /// Số lịch còn lại ngoài lịch đầu tiên
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
    final background =
        isToday ? AppColors.softMint : Colors.white;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                ),

                const SizedBox(height: 10),

                if (item == null) ...[
                  const Icon(
                    Icons.event_available_outlined,
                    color: Colors.grey,
                    size: 22,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Trống",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ] else ...[
                  Text(
                    "${item!.startTime} - ${item!.endTime}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: item!.isSession
                          ? Colors.green.shade100
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item!.title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: item!.isSession
                            ? Colors.green.shade800
                            : Colors.blue.shade800,
                      ),
                    ),
                  ),

                  if (extraCount > 0) ...[
                    const SizedBox(height: 6),
                    Text(
                      "+$extraCount",
                      style: const TextStyle(
                        fontSize: 11,
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
      ),
    );
  }
}