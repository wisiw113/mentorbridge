
import 'package:flutter/material.dart';

class SessionTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const SessionTimePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  static const List<TimeOfDay> timeSlots = [
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 8, minute: 30),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 9, minute: 30),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 10, minute: 30),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 11, minute: 30),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 13, minute: 30),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 14, minute: 30),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 15, minute: 30),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 16, minute: 30),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 17, minute: 30),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 18, minute: 30),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 19, minute: 30),
    TimeOfDay(hour: 20, minute: 0),
  ];

  String _formatTime(TimeOfDay time) {
    final hour =
        time.hour.toString().padLeft(2, '0');

    final minute =
        time.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TimeOfDay>(
      value: selectedTime,
      decoration: InputDecoration(
        labelText: "Start Time",
        prefixIcon: const Icon(
          Icons.access_time_outlined,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
      items: timeSlots.map((time) {
        return DropdownMenuItem<TimeOfDay>(
          value: time,
          child: Text(
            _formatTime(time),
          ),
        );
      }).toList(),
      onChanged: (time) {
        if (time != null) {
          onTimeSelected(time);
        }
      },
    );
  }
}

