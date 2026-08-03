import 'package:flutter/material.dart';

class AppointmentInfoCard extends StatelessWidget {
  final String date;
  final String time;
  final String topic;
  final String note;

  const AppointmentInfoCard({
    super.key,
    required this.date,
    required this.time,
    required this.topic,
    required this.note,
  });

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
              'Appointment Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _InfoRow(
              icon: Icons.calendar_today,
              title: 'Date',
              value: date,
            ),

            _InfoRow(
              icon: Icons.access_time,
              title: 'Time',
              value: time,
            ),

            _InfoRow(
              icon: Icons.topic,
              title: 'Topic',
              value: topic,
            ),

            _InfoRow(
              icon: Icons.notes,
              title: 'Note',
              value:
                  note.isEmpty ? 'No note' : note,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}