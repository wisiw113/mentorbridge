import 'package:flutter/material.dart';

class AppointmentStatusFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const AppointmentStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  static const List<String> statuses = [
    "all",
    "pending",
    "accepted",
    "rejected",
    "completed",
  ];

  String _getLabel(String status) {
    switch (status) {
      case "pending":
        return "Pending";
      case "accepted":
        return "Accepted";
      case "rejected":
        return "Rejected";
      case "completed":
        return "Completed";
      default:
        return "All";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: statuses.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected =
              selectedStatus == status;

          return ChoiceChip(
            label: Text(
              _getLabel(status),
            ),
            selected: isSelected,
            onSelected: (_) {
              onChanged(status);
            },
            selectedColor: Colors.green,
            backgroundColor: Colors.grey.shade100,
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}