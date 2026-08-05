
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminUserHeader extends StatelessWidget {
  final int totalUsers;

  const AdminUserHeader({
    super.key,
    required this.totalUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ICON
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.softMint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.people_outline,
              color: AppColors.deepGreen,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          // TITLE + DESCRIPTION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Management',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$totalUsers users in the system',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),

          // TOTAL
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.mintGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '$totalUsers',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mintGreen,
                  ),
                ),
                const Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.gray,
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

