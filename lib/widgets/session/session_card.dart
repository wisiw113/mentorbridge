import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;

  final int bookedSlots;
  final int maxSlots;

  final String status;

  final VoidCallback? onTap;
  final VoidCallback? onJoin;

  const SessionCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.bookedSlots,
    required this.maxSlots,
    required this.status,
    this.onTap,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (status.toLowerCase()) {
      case "completed":
        statusColor = AppColors.completed;
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

    final double percent =
        maxSlots == 0 ? 0 : bookedSlots / maxSlots;

    final bool canJoin =
        onJoin != null &&
        status.toLowerCase() == "open" &&
        bookedSlots < maxSlots;

    return Card(
      color: AppColors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepGreen,
                ),
              ),

              const SizedBox(height: 6),

              // DESCRIPTION
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.gray,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 12),

              // DATE
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: AppColors.mintGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // TIME
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 18,
                    color: AppColors.mintGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$startTime - $endTime",
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // AVAILABLE SLOTS
              const Text(
                "Available Slots",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),

              const SizedBox(height: 6),

              LinearProgressIndicator(
                value: percent,
                minHeight: 6,
                borderRadius: BorderRadius.circular(20),
                backgroundColor: AppColors.border,
                valueColor:
                    const AlwaysStoppedAnimation(
                  AppColors.mintGreen,
                ),
              ),

              const SizedBox(height: 5),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "$bookedSlots / $maxSlots",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.deepGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // STATUS + JOIN
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(.35),
                      ),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (canJoin)
                    ElevatedButton.icon(
                      onPressed: onJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.mintGreen,
                        foregroundColor:
                            AppColors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.groups,
                        size: 17,
                      ),
                      label: const Text(
                        "Join",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}