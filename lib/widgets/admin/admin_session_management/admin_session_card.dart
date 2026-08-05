
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminSessionCard extends StatelessWidget {
  final String title;
  final String mentorName;
  final String date;
  final String startTime;
  final String endTime;
  final int bookedSlots;
  final int maxSlots;
  final String status;
  final bool hasFile;

  final VoidCallback onViewDetails;

  const AdminSessionCard({
    super.key,
    required this.title,
    required this.mentorName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.bookedSlots,
    required this.maxSlots,
    required this.status,
    required this.hasFile,
    required this.onViewDetails,
  });

  Color _statusColor() {
    switch (status) {
      case 'open':
        return AppColors.success;

      case 'full':
        return AppColors.warning;

      case 'running':
        return AppColors.mintGreen;

      case 'completed':
        return AppColors.completed;

      case 'cancelled':
        return AppColors.cancelled;

      default:
        return AppColors.gray;
    }
  }

  String _statusText() {
    switch (status) {
      case 'open':
        return 'Open';

      case 'full':
        return 'Full';

      case 'running':
        return 'Running';

      case 'completed':
        return 'Completed';

      case 'cancelled':
        return 'Cancelled';

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border.withOpacity(0.08),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // TITLE + STATUS
          // =====================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =====================================================
          // MENTOR
          // =====================================================

          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: AppColors.deepGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mentorName.isEmpty
                      ? 'Unknown mentor'
                      : mentorName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // =====================================================
          // DATE + TIME
          // =====================================================

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.deepGreen,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.access_time_rounded,
                size: 17,
                color: AppColors.deepGreen,
              ),
              const SizedBox(width: 6),
              Text(
                '$startTime - $endTime',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =====================================================
          // BOTTOM
          // =====================================================

          Row(
            children: [
              Icon(
                Icons.groups_outlined,
                size: 18,
                color: AppColors.gray,
              ),
              const SizedBox(width: 6),
              Text(
                '$bookedSlots / $maxSlots participants',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ),

              if (hasFile) ...[
                const SizedBox(width: 14),
                const Icon(
                  Icons.attach_file_rounded,
                  size: 17,
                  color: AppColors.deepGreen,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Document',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
              ],

              const Spacer(),

              TextButton(
                onPressed: onViewDetails,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.deepGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
                child: const Text(
                  'Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

