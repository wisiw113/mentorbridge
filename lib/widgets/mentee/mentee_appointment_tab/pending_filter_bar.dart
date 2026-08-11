
import 'package:flutter/material.dart';

class PendingFilterBar extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const PendingFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  // =========================================================
  // DANH SÁCH TRẠNG THÁI
  // =========================================================

  static const List<String> statuses = [
    'all',
    'pending',
    'accepted',
    'completed',
    'rejected',
    'cancelled',
  ];

  // =========================================================
  // HIỂN THỊ TÊN TRẠNG THÁI
  // =========================================================

  String _getLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Đang chờ';

      case 'accepted':
        return 'Đã chấp nhận';

      case 'completed':
        return 'Đã hoàn thành';

      case 'rejected':
        return 'Đã từ chối';

      case 'cancelled':
        return 'Đã hủy';

      case 'all':
      default:
        return 'Tất cả';
    }
  }

  // =========================================================
  // ICON TRẠNG THÁI
  // =========================================================

  IconData _getIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule_outlined;

      case 'accepted':
        return Icons.check_circle_outline;

      case 'completed':
        return Icons.task_alt_rounded;

      case 'rejected':
        return Icons.cancel_outlined;

      case 'cancelled':
        return Icons.block_outlined;

      case 'all':
      default:
        return Icons.apps_outlined;
    }
  }

  // =========================================================
  // MÀU TRẠNG THÁI
  // =========================================================

  Color _getColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;

      case 'accepted':
        return Colors.green;

      case 'completed':
        return Colors.blue;

      case 'rejected':
        return Colors.red;

      case 'cancelled':
        return Colors.grey;

      case 'all':
      default:
        return Colors.green;
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: statuses.length,
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 8,
          );
        },
        itemBuilder: (
          context,
          index,
        ) {
          final status = statuses[index];

          final isSelected =
              selectedStatus == status;

          final color = _getColor(status);

          return ChoiceChip(
            selected: isSelected,

            onSelected: (_) {
              onChanged(status);
            },

            // =================================================
            // ICON
            // =================================================

            avatar: Icon(
              _getIcon(status),
              size: 17,
              color: isSelected
                  ? Colors.white
                  : color,
            ),

            // =================================================
            // TÊN HIỂN THỊ
            // =================================================

            label: Text(
              _getLabel(status),
            ),

            // =================================================
            // MÀU KHI ĐƯỢC CHỌN
            // =================================================

            selectedColor: color,

            // =================================================
            // MÀU NỀN
            // =================================================

            backgroundColor:
                Colors.grey.shade100,

            // =================================================
            // BORDER
            // =================================================

            side: BorderSide(
              color: isSelected
                  ? color
                  : Colors.grey.shade300,
            ),

            // =================================================
            // BO GÓC
            // =================================================

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),

            // =================================================
            // TEXT STYLE
            // =================================================

            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black87,
              fontSize: 13,
              fontWeight:
                  FontWeight.w600,
            ),

            // =================================================
            // PADDING
            // =================================================

            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
          );
        },
      ),
    );
  }
}

