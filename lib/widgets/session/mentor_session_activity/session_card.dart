import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;

  final int bookedSlots;
  final int maxSlots;

  final String status;

  // =========================
  // RATING
  // =========================

  final double averageRating;
  final int reviewCount;

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
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.onTap,
    this.onJoin,
  });

  // =========================================================
  // STATUS COLOR
  // =========================================================

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "completed":
        return AppColors.completed;

      case "full":
        return AppColors.warning;

      case "cancelled":
        return AppColors.error;

      default:
        return AppColors.success;
    }
  }

  // =========================================================
  // STATUS TEXT
  // =========================================================

  String _getStatusText() {
    switch (status.toLowerCase()) {
      case "open":
        return "Đang mở";

      case "full":
        return "Đã đầy";

      case "completed":
        return "Đã hoàn thành";

      case "cancelled":
        return "Đã hủy";

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    final double percent = maxSlots == 0
        ? 0
        : (bookedSlots / maxSlots).clamp(0.0, 1.0);

    // GIỮ NGUYÊN LOGIC CŨ
    final bool canJoin =
        onJoin != null &&
        status.toLowerCase() == "open" &&
        bookedSlots < maxSlots;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =================================================
              // HEADER
              // =================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ICON SESSION
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.lightMint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      color: AppColors.deepGreen,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // TITLE + DESCRIPTION
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepGreen,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          description.trim().isNotEmpty
                              ? description
                              : "Không có mô tả",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =================================================
              // RATING
              // =================================================

              if (reviewCount > 0)
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 21,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      "($reviewCount đánh giá)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

              if (reviewCount == 0)
                Row(
                  children: [
                    Icon(
                      Icons.star_border_rounded,
                      color: Colors.grey.shade400,
                      size: 21,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      "Chưa có đánh giá",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // =================================================
              // DATE
              // =================================================

              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: "Ngày",
                value: date,
              ),

              const SizedBox(height: 10),

              // =================================================
              // TIME
              // =================================================

              _InfoRow(
                icon: Icons.access_time_outlined,
                label: "Thời gian",
                value: "$startTime - $endTime",
              ),

              const SizedBox(height: 16),

              // =================================================
              // AVAILABLE SLOTS
              // =================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Số người tham gia",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    "$bookedSlots / $maxSlots",
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.deepGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              LinearProgressIndicator(
                value: percent,
                minHeight: 7,
                borderRadius: BorderRadius.circular(20),
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(
                  AppColors.mintGreen,
                ),
              ),

              const SizedBox(height: 16),

              // =================================================
              // STATUS + JOIN
              // =================================================

              Row(
                children: [
                  // STATUS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          _getStatusText(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // JOIN
                  if (canJoin)
                    ElevatedButton.icon(
                      onPressed: onJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mintGreen,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.group_add_outlined,
                        size: 17,
                      ),
                      label: const Text(
                        "Tham gia",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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

// =========================================================
// INFO ROW
// =========================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.mintGreen,
        ),

        const SizedBox(width: 10),

        Text(
          "$label: ",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
        ),
      ],
    );
  }
}