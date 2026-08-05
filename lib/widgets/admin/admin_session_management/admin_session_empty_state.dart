
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminSessionEmptyState extends StatelessWidget {
  final String message;

  const AdminSessionEmptyState({
    super.key,
    this.message = 'No sessions found',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 70,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.softMint.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_outlined,
                size: 34,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'There are no sessions matching your filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

