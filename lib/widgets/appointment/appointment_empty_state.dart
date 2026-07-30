import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppointmentEmptyState extends StatelessWidget {
  final String message;

  const AppointmentEmptyState({
    super.key,
    this.message = "Không có lịch hẹn nào.",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                size: 50,
                color: AppColors.mintGreen,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "No Requests Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}