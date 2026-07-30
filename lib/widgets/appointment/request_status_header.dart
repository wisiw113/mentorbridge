import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/appointment_model.dart';

class RequestStatusHeader extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const RequestStatusHeader({
    super.key,
    required this.appointments,
  });

  int _countByStatus(String status) {
    return appointments
        .where(
          (item) =>
              item.status.toLowerCase() ==
              status.toLowerCase(),
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final pending = _countByStatus("pending");
    final accepted = _countByStatus("accepted");
    final completed = _countByStatus("completed");

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStat(
              icon: Icons.hourglass_top,
              title: "Pending",
              value: pending,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _buildStat(
              icon: Icons.check_circle_outline,
              title: "Accepted",
              value: accepted,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _buildStat(
              icon: Icons.done_all,
              title: "Completed",
              value: completed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String title,
    required int value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 24,
          ),

          const SizedBox(height: 6),

          Text(
            "$value",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}