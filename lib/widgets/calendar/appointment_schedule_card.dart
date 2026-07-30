import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';

class AppointmentScheduleCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;

  const AppointmentScheduleCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (appointment.status.toLowerCase()) {
      case 'completed':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'pending':
        return Colors.orange;

      case 'accepted':
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                statusColor.withOpacity(0.1),
            child: Icon(
              Icons.calendar_today,
              color: statusColor,
            ),
          ),

          title: Text(
            appointment.menteeName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '${appointment.time}\n'
              '${appointment.note}',
            ),
          ),

          isThreeLine: true,

          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointment.status.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

