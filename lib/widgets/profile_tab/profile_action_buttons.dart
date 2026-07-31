
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final Future<void> Function() onLogout;

  const ProfileActionButtons({
    super.key,
    required this.onEdit,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
              ),
              label: const Text(
                "Edit Profile",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepGreen,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => onLogout(),
              icon: const Icon(
                Icons.logout,
                size: 18,
              ),
              label: const Text(
                "Logout",
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.deepGreen,
                side: const BorderSide(
                  color: AppColors.deepGreen,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

