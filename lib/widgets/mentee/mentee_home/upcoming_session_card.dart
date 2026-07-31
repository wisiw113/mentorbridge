
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/session_model.dart';

class UpcomingSessionCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback? onPressed;

  const UpcomingSessionCard({
    super.key,
    required this.session,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.softMint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: AppColors.deepGreen,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Session sắp tham gia',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        session.title,
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
              ],
            ),

            const SizedBox(height: 16),

            const Divider(height: 1),

            const SizedBox(height: 16),

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
                    session.mentorName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

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
                    _formatDate(session.date),
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
                    '${session.startTime} - ${session.endTime}',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ======================================================
            // PARTICIPANTS
            // ======================================================

            Row(
              children: [
                const Icon(
                  Icons.people_outline_rounded,
                  size: 19,
                  color: AppColors.deepGreen,
                ),

                const SizedBox(width: 8),

                Text(
                  '${session.bookedSlots}/${session.maxSlots} participants',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray,
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
                  'Xem Session',
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

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    return date.toString();
  }
}
