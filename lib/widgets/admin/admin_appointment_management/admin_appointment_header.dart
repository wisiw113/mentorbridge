import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminAppointmentHeader extends StatelessWidget {
  final int totalAppointments;

  const AdminAppointmentHeader({
    super.key,
    required this.totalAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.softMint.withOpacity(.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softMint,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.mintGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_note_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Appointments",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$totalAppointments total appointments",
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),

          Text(
            totalAppointments.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),
        ],
      ),
    );
  }
}