import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class MentorBookingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MentorBookingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(
            Icons.calendar_month_rounded,
            color: Colors.white,
          ),
          label: const Text(
            "Đặt lịch với Mentor",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mintGreen,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}