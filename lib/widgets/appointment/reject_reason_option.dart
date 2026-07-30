import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class RejectReasonOption extends StatelessWidget {
  final String reason;
  final bool isSelected;
  final VoidCallback onTap;

  const RejectReasonOption({
    super.key,
    required this.reason,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.error.withOpacity(0.08)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.error
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.error
                  : AppColors.gray,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                reason,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: AppColors.darkGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}