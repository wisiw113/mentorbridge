import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class MentorHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final double rating;
  final int totalRating;

  const MentorHeader({
    super.key,
    required this.name,
    required this.email,
    required this.rating,
    required this.totalRating,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.mintGreen,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.lightMint,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      name.isEmpty ? "?" : name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            email,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.gray,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightMint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      size: 18,
                      color: AppColors.mintGreen,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Mentor",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " ($totalRating)",
                      style: const TextStyle(
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}