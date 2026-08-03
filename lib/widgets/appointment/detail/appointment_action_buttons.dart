import 'package:flutter/material.dart';

class AppointmentActionButtons extends StatelessWidget {
  final bool isMentor;
  final bool canComplete;
  final bool canCancel;
  final String status;

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const AppointmentActionButtons({
    super.key,
    required this.isMentor,
    required this.canComplete,
    required this.canCancel,
    required this.status,
    required this.onAccept,
    required this.onReject,
    required this.onComplete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isMentor && status == 'pending') ...[
          ElevatedButton(
            onPressed: onAccept,
            child: const Text(
              'Accept Appointment',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onReject,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'Reject Appointment',
            ),
          ),
        ],

        if (canComplete)
          ElevatedButton.icon(
            onPressed: onComplete,
            icon: const Icon(Icons.check),
            label: const Text(
              'Complete Appointment',
            ),
          ),

        if (canCancel) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(
              Icons.cancel_outlined,
            ),
            label: const Text(
              'Cancel Appointment',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}