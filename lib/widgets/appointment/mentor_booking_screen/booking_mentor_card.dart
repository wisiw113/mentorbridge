import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class BookingMentorCard extends StatelessWidget {
  final String mentorName;

  const BookingMentorCard({
    super.key,
    required this.mentorName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor:
                  AppColors.lightMint,
              child: const Icon(
                Icons.person,
                size: 38,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              mentorName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Mentor",
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius:
                    BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: AppColors.deepGreen,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Appointment 1 : 1",
                    style: TextStyle(
                      color:
                          AppColors.deepGreen,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}