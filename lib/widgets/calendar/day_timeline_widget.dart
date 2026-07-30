import 'package:flutter/material.dart';

class DayTileWidget extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool hasBooking;
  final VoidCallback onTap;

  const DayTileWidget({
    super.key,
    required this.date,
    required this.isToday,
    required this.hasBooking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isToday
              ? Colors.blue
              : hasBooking
                  ? Colors.orange.shade200
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${date.day}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isToday ? Colors.white : Colors.black,
                ),
              ),

              if (hasBooking)
                const Icon(
                  Icons.circle,
                  size: 6,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }
}