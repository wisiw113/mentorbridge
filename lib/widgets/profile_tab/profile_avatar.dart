
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String? photoURL;
  final bool isUploading;
  final VoidCallback onCameraTap;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.photoURL,
    required this.isUploading,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.softMint,
          backgroundImage: photoURL != null
              ? NetworkImage(photoURL!)
              : null,
          child: photoURL == null
              ? Text(
                  name.isNotEmpty
                      ? name[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                )
              : null,
        ),
        GestureDetector(
          onTap: onCameraTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.deepGreen,
              shape: BoxShape.circle,
            ),
            child: isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(
                    Icons.camera_alt,
                    size: 17,
                    color: AppColors.white,
                  ),
          ),
        ),
      ],
    );
  }
}
