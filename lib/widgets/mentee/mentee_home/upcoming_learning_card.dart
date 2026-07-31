
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/schedule_item.dart';

class UpcomingLearningCard extends StatelessWidget {
  final ScheduleItem item;
  final VoidCallback? onPressed;

  const UpcomingLearningCard({
    super.key,
    required this.item,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSession = item.isSession;

    final session = item.session;
    final appointment = item.appointment;

    // Lấy thông tin hiển thị
    final title = isSession
        ? session?.title ?? 'Session'
        : appointment?.topic ?? 'Appointment';

    final mentorName = isSession
        ? session?.mentorName ?? 'Mentor'
        : appointment?.mentorName ?? 'Mentor';

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // HEADER
            // ======================================================

            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSession
                        ? AppColors.softMint
                        : Colors.blue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isSession
                        ? Icons.groups_rounded
                        : Icons.calendar_today_rounded,
                    color: isSession
                        ? AppColors.deepGreen
                        : Colors.blue,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upcoming Learning',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepGreen,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSession
                        ? AppColors.softMint
                        : Colors.blue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSession ? 'Session' : 'Appointment',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSession
                          ? AppColors.deepGreen
                          : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(height: 1),

            const SizedBox(height: 16),

            // ======================================================
            // DATE
            // ======================================================

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.deepGreen,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    _formatDate(item.startAt),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ======================================================
            // TIME
            // ======================================================

            Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  size: 18,
                  color: AppColors.warning,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    '${item.startTime} - ${item.endTime}',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ======================================================
            // MENTOR
            // ======================================================

            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 19,
                  color: AppColors.deepGreen,
                ),

                const SizedBox(width: 8),

                const Text(
                  'Mentor:',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.gray,
                  ),
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    mentorName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ======================================================
            // BUTTON
            // ======================================================

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.deepGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

