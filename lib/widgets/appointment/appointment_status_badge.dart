import 'package:flutter/material.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final String status;

  const AppointmentStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 13,
            color: config.color,
          ),

          const SizedBox(width: 5),

          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig() {
    switch (status.toLowerCase()) {
      case "accepted":
        return const _StatusConfig(
          label: "Accepted",
          color: Colors.green,
          icon: Icons.check_circle_outline,
        );

      case "rejected":
        return const _StatusConfig(
          label: "Rejected",
          color: Colors.red,
          icon: Icons.cancel_outlined,
        );

      case "completed":
        return const _StatusConfig(
          label: "Completed",
          color: Colors.blue,
          icon: Icons.done_all,
        );

      case "pending":
      default:
        return const _StatusConfig(
          label: "Pending",
          color: Colors.orange,
          icon: Icons.access_time,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}