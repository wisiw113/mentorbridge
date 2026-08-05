
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminUserFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const AdminUserFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  static const List<String> _statuses = [
    'all',
    'pending',
    'approved',
    'rejected',
  ];

  String _getLabel(String status) {
    switch (status) {
      case 'all':
        return 'All';

      case 'pending':
        return 'Pending';

      case 'approved':
        return 'Approved';

      case 'rejected':
        return 'Rejected';

      default:
        return status;
    }
  }

  IconData _getIcon(String status) {
    switch (status) {
      case 'all':
        return Icons.people_outline;

      case 'pending':
        return Icons.access_time;

      case 'approved':
        return Icons.check_circle_outline;

      case 'rejected':
        return Icons.cancel_outlined;

      default:
        return Icons.filter_list;
    }
  }

  Color _getColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.pending;

      case 'approved':
        return AppColors.success;

      case 'rejected':
        return AppColors.error;

      case 'all':
      default:
        return AppColors.deepGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _statuses.map((status) {
          final isSelected = selectedStatus == status;
          final color = _getColor(status);

          return Padding(
            padding: EdgeInsets.only(
              right: status == _statuses.last ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => onStatusChanged(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? color
                        : AppColors.border.withOpacity(0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIcon(status),
                      size: 17,
                      color: isSelected
                          ? AppColors.white
                          : color,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      _getLabel(status),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

