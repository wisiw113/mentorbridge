import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminAppointmentCard extends StatelessWidget {
  final String mentorName;
  final String menteeName;

  final String topic;

  final String date;
  final String startTime;
  final String endTime;

  final String status;

  final bool rated;

  final VoidCallback onViewDetails;

  const AdminAppointmentCard({
    super.key,
    required this.mentorName,
    required this.menteeName,
    required this.topic,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.rated,
    required this.onViewDetails,
  });

  Color _statusColor() {
    switch (status) {
      case "pending":
        return AppColors.pending;

      case "accepted":
        return AppColors.accepted;

      case "completed":
        return AppColors.completed;

      case "cancelled":
        return AppColors.cancelled;

      case "rejected":
        return AppColors.error;

      default:
        return AppColors.gray;
    }
  }

  String _statusText() {
    switch (status) {
      case "pending":
        return "Pending";

      case "accepted":
        return "Accepted";

      case "completed":
        return "Completed";

      case "cancelled":
        return "Cancelled";

      case "rejected":
        return "Rejected";

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black12,
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
          //--------------------------------------------------
          // Topic + Status
          //--------------------------------------------------

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  topic,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          //--------------------------------------------------
          // Mentor
          //--------------------------------------------------

          Row(
            children: [
              const Icon(
                Icons.school_outlined,
                size: 18,
                color: AppColors.deepGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mentorName,
                  style: const TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          //--------------------------------------------------
          // Mentee
          //--------------------------------------------------

          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
                color: AppColors.deepGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  menteeName,
                  style: const TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          //--------------------------------------------------
          // Date
          //--------------------------------------------------

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: AppColors.deepGreen,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.gray,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          //--------------------------------------------------
          // Time
          //--------------------------------------------------

          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 17,
                color: AppColors.deepGreen,
              ),
              const SizedBox(width: 8),
              Text(
                "$startTime - $endTime",
                style: const TextStyle(
                  color: AppColors.gray,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const Divider(height: 26),

          //--------------------------------------------------
          // Bottom
          //--------------------------------------------------

          Row(
            children: [
              Icon(
                rated
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: rated
                    ? Colors.amber
                    : AppColors.gray,
                size: 20,
              ),

              const SizedBox(width: 6),

              Text(
                rated
                    ? "Rated"
                    : "Not Rated",
                style: TextStyle(
                  color: rated
                      ? Colors.amber.shade700
                      : AppColors.gray,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),

              const Spacer(),

              TextButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 18,
                ),
                label: const Text("Details"),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.deepGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}