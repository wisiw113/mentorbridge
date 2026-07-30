import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SessionStatusChip extends StatelessWidget {
  final String status;

  const SessionStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String text;

    switch (status.toLowerCase()) {
      case "open":
        color = AppColors.success;
        icon = Icons.check_circle;
        text = "OPEN";
        break;

      case "full":
        color = AppColors.warning;
        icon = Icons.groups;
        text = "FULL";
        break;

      case "completed":
        color = AppColors.deepGreen;
        icon = Icons.task_alt;
        text = "COMPLETED";
        break;

      case "cancelled":
        color = AppColors.error;
        icon = Icons.cancel;
        text = "CANCELLED";
        break;

      default:
        color = AppColors.gray;
        icon = Icons.help_outline;
        text = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: .4,
            ),
          ),
        ],
      ),
    );
  }
}