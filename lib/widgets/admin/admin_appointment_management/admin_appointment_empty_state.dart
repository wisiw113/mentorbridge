import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminAppointmentEmptyState extends StatelessWidget {
  const AdminAppointmentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.softMint.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_outlined,
                size: 72,
                color: AppColors.mintGreen,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "No Appointments Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "There are currently no appointments matching the selected filter.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}