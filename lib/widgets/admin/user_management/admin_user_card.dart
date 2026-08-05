
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminUserCard extends StatelessWidget {
  final String email;
  final String role;
  final String status;

  final VoidCallback onEdit;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onDelete;

  const AdminUserCard({
    super.key,
    required this.email,
    required this.role,
    required this.status,
    required this.onEdit,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.success;

      case 'rejected':
        return AppColors.error;

      case 'pending':
        return AppColors.pending;

      default:
        return AppColors.gray;
    }
  }

  String _getStatusText() {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';

      case 'rejected':
        return 'Rejected';

      case 'pending':
        return 'Pending';

      default:
        return status.isEmpty ? 'Unknown' : status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.border.withOpacity(0.08),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =========================
            // USER INFO
            // =========================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AVATAR
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.softMint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.deepGreen,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                // EMAIL + ROLE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGray,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Role: $role',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),

                // STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // DIVIDER
            Divider(
              height: 1,
              color: AppColors.border.withOpacity(0.08),
            ),

            const SizedBox(height: 10),

            // =========================
            // ACTIONS
            // =========================
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionButton(
                  tooltip: 'Edit',
                  icon: Icons.edit_outlined,
                  color: AppColors.deepGreen,
                  onPressed: onEdit,
                ),

                const SizedBox(width: 4),

                _ActionButton(
                  tooltip: 'Approve',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  onPressed: onApprove,
                ),

                const SizedBox(width: 4),

                _ActionButton(
                  tooltip: 'Reject',
                  icon: Icons.cancel_outlined,
                  color: AppColors.warning,
                  onPressed: onReject,
                ),

                const SizedBox(width: 4),

                _ActionButton(
                  tooltip: 'Delete',
                  icon: Icons.delete_outline,
                  color: AppColors.error,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// ACTION BUTTON
// =====================================================

class _ActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 21,
        color: color,
      ),
      splashRadius: 20,
    );
  }
}

