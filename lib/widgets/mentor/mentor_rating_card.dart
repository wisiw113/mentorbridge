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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Đánh giá",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),

          const SizedBox(height: 16),

          Icon(
            Icons.star_rounded,
            color: Colors.amber,
            size: 50,
          ),

          const SizedBox(height: 8),

          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < rating.round()
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Colors.amber,
                size: 26,
              );
            }),
          ),

          const SizedBox(height: 10),

          Text(
            "$totalRating lượt đánh giá",
            style: const TextStyle(
              color: AppColors.gray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}