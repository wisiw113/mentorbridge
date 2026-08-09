import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminAppointmentFilter extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const AdminAppointmentFilter({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  static const List<String> filters = [
    "All",
    "Pending",
    "Accepted",
    "Rejected",
    "Cancelled",
    "Completed",
  ];

  Color _color(String filter) {
    switch (filter) {
      case "Pending":
        return AppColors.pending;

      case "Accepted":
        return AppColors.accepted;

      case "Rejected":
        return AppColors.error;

      case "Cancelled":
        return AppColors.cancelled;

      case "Completed":
        return AppColors.completed;

      default:
        return AppColors.deepGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];

          final isSelected =
              selectedFilter == filter;

          final color = _color(filter);

          return InkWell(
            borderRadius:
                BorderRadius.circular(20),
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              curve: Curves.easeInOut,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(.12)
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? color
                      : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? color
                        : AppColors.gray,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}