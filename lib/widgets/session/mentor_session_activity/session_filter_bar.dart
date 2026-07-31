import 'package:flutter/material.dart';

class SessionFilterBar extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const SessionFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  static const List<String> statuses = [
    'all',
    'open',
    'accepted',
    'cancelled',
    'completed',
  ];

  String _getLabel(String status) {
    switch (status) {
      case 'open':
        return 'Open';
      case 'accepted':
        return 'Accepted';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = statuses[index];

          return ChoiceChip(
            label: Text(_getLabel(status)),
            selected: selectedStatus == status,
            onSelected: (_) => onChanged(status),
            selectedColor: Colors.green,
            backgroundColor: Colors.grey.shade100,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelStyle: TextStyle(
              color: selectedStatus == status
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }
}