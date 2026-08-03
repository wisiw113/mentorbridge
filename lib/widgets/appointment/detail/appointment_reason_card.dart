import 'package:flutter/material.dart';

class AppointmentReasonCard extends StatelessWidget {
  final String title;
  final String reason;

  const AppointmentReasonCard({
    super.key,
    required this.title,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(reason),
          ],
        ),
      ),
    );
  }
}