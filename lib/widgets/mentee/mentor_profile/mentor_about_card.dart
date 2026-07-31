import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MentorAboutCard extends StatelessWidget {
  final String about;

  const MentorAboutCard({
    super.key,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    final hasAbout = about.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen
                      .withOpacity(.12),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.deepGreen,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                "About Mentor",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (hasAbout)
            Text(
              about,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.darkGray,
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softMint
                    .withOpacity(.35),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Text(
                "Mentor chưa cập nhật thông tin giới thiệu.",
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
 
