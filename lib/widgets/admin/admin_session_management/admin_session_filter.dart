
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminSessionFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const AdminSessionFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  static const List<Map<String, String>> filters = [
    {
      'value': 'all',
      'label': 'All',
    },
    {
      'value': 'open',
      'label': 'Open',
    },
    {
      'value': 'full',
      'label': 'Full',
    },
    {
      'value': 'running',
      'label': 'Running',
    },
    {
      'value': 'completed',
      'label': 'Completed',
    },
    {
      'value': 'cancelled',
      'label': 'Cancelled',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withOpacity(0.08),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final value = filter['value']!;
            final label = filter['label']!;
            final isSelected = selectedStatus == value;

            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () => onStatusChanged(value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mintGreen
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.gray,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
