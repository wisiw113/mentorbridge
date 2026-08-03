import 'package:flutter/material.dart';

class AppointmentScheduleCard extends StatelessWidget {
  final DateTime startAt;
  final DateTime endAt;

  const AppointmentScheduleCard({
    super.key,
    required this.startAt,
    required this.endAt,
  });

  String _format(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Start: ${_format(startAt)}'),
            const SizedBox(height: 8),
            Text('End: ${_format(endAt)}'),
          ],
        ),
      ),
    );
  }
}