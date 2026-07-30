import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class BookingNoteField extends StatelessWidget {
  final TextEditingController controller;

  const BookingNoteField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          "Ghi chú",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 300,
          decoration: InputDecoration(
            hintText:
                "Nhập nội dung muốn mentor biết trước...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.mintGreen,
                width: 2,
              ),
            ),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}