import 'package:flutter/material.dart';

class TimeSlotWidget extends StatelessWidget {
  final String time;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotWidget({
    super.key,
    required this.time,
    required this.isBooked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isBooked
              ? Colors.grey
              : isSelected
                  ? Colors.green
                  : Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isBooked ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}