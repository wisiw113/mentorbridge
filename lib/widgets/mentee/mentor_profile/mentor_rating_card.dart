
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class MentorRating extends StatelessWidget {
  final double rating;
  final int totalRating;

  const MentorRating({
    super.key,
    required this.rating,
    required this.totalRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // HEADER
          // =====================================================

          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đánh giá",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Đánh giá từ người học",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),

              // SCORE
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepGreen,
                ),
              ),

              const SizedBox(width: 4),

              const Text(
                "/ 5",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =====================================================
          // RATING
          // =====================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.035),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // STARS
                Row(
                  children: List.generate(
                    5,
                    (index) {
                      final roundedRating =
                          rating.round();

                      return Icon(
                        index < roundedRating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 23,
                      );
                    },
                  ),
                ),

                const Spacer(),

                // TOTAL
                Text(
                  "$totalRating lượt đánh giá",
                  style: const TextStyle(
                    color: AppColors.gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

