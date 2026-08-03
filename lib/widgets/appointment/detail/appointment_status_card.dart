import 'package:flutter/material.dart';

class AppointmentStatusCard extends StatelessWidget {
  final String status;

  const AppointmentStatusCard({
    super.key,
    required this.status,
  });

  String get _text {
    switch (status) {
      case 'pending':
        return 'Đang chờ Mentor xác nhận';
      case 'accepted':
        return 'Đã được chấp nhận';
      case 'rejected':
        return 'Đã bị từ chối';
      case 'cancelled':
        return 'Đã hủy';
      case 'completed':
        return 'Đã hoàn thành';
      default:
        return status;
    }
  }

  Color get _color {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: _color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _text,
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}