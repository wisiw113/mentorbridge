import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AvatarPreviewPopup extends StatelessWidget {
  final File imageFile;

  const AvatarPreviewPopup({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Xác nhận ảnh",
        style: TextStyle(
          color: AppColors.deepGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              imageFile,
              height: 220,
              width: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Bạn có muốn sử dụng ảnh này làm avatar không?",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.darkGray),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Không",
            style: TextStyle(color: AppColors.gray),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mintGreen,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Có"),
        ),
      ],
    );
  }
}