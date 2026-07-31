import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/appointment_model.dart';
import '../../../../services/appointment_service.dart';

class RequestCard extends StatelessWidget {
  final List<AppointmentModel> requests;

  const RequestCard({
    super.key,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    final pendingRequests = requests
        .where((request) => request.status == "pending")
        .toList();

    if (pendingRequests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: AppColors.deepGreen,
                ),
                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    "Connection Requests",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.red,
                  child: Text(
                    pendingRequests.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ...pendingRequests.take(3).map(
                  (appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RequestItem(
                      appointment: appointment,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  final AppointmentModel appointment;

  const RequestItem({
    super.key,
    required this.appointment,
  });

  Future<void> _updateStatus(String status) async {
    await AppointmentService().updateStatus(
      appointment.id,
      status,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.menteeName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            appointment.topic,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(appointment.date),

              const SizedBox(width: 16),

              const Icon(
                Icons.access_time,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(appointment.time),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _updateStatus("rejected"),
                  child: const Text("Reject"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateStatus("accepted"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mintGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Accept"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}