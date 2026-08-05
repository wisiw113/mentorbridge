
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminUserEmptyState extends StatelessWidget {
  const AdminUserEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ICON
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.softMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 36,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 16),

            // TITLE
            const Text(
              'No users found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 6),

            // DESCRIPTION
            const Text(
              'There are no users to display at the moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
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

