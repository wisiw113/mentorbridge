import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SessionInfoCard extends StatelessWidget {
  final String title;
  final String description;

  final String mentorName;

  final String date;
  final String startTime;
  final String endTime;

  final int bookedSlots;
  final int maxSlots;

  final String status;

  const SessionInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.mentorName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.bookedSlots,
    required this.maxSlots,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (status.toLowerCase()) {
      case "completed":
        statusColor = AppColors.deepGreen;
        break;

      case "full":
        statusColor = AppColors.warning;
        break;

      case "cancelled":
        statusColor = AppColors.error;
        break;

      default:
        statusColor = AppColors.success;
    }

    final progress =
        maxSlots == 0 ? 0.0 : bookedSlots / maxSlots;

    return Card(
      color: AppColors.white,
      elevation: 5,
      shadowColor: AppColors.deepGreen.withOpacity(.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 18),

            /// DESCRIPTION
            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              description,
              style: const TextStyle(
                color: AppColors.gray,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 10),

            _InfoRow(
              icon: Icons.person,
              title: "Mentor",
              value: mentorName,
            ),

            const SizedBox(height: 12),

            _InfoRow(
              icon: Icons.calendar_month,
              title: "Date",
              value: date,
            ),

            const SizedBox(height: 12),

            _InfoRow(
              icon: Icons.schedule,
              title: "Time",
              value: "$startTime - $endTime",
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 10),

            const Text(
              "Participants",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(20),
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.mintGreen,
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$bookedSlots / $maxSlots joined",
                style: const TextStyle(
                  color: AppColors.deepGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
                  "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.mintGreen,
          size: 22,
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 70,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.gray,
            ),
          ),
        ),
      ],
    );
  }
}