import 'package:flutter/material.dart';

class SessionDurationSelector extends StatelessWidget {
  final int selectedDuration;
  final ValueChanged<int> onChanged;

  const SessionDurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> durations = [
    {
      "value": 60,
      "label": "1 giờ",
    },
    {
      "value": 90,
      "label": "1 giờ 30 phút",
    },
    {
      "value": 120,
      "label": "2 giờ",
    },
    {
      "value": 150,
      "label": "2 giờ 30 phút",
    },
    {
      "value": 180,
      "label": "3 giờ",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedDuration,
      decoration: InputDecoration(
        labelText: "Session Duration",
        prefixIcon: const Icon(
          Icons.timer_outlined,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: durations.map((duration) {
        return DropdownMenuItem<int>(
          value: duration["value"] as int,
          child: Text(
            duration["label"] as String,
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}