
import 'package:flutter/material.dart';

class SessionFilterBar extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const SessionFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  // =========================================================
  // SESSION STATUS
  // Phải khớp với SessionModel
  // =========================================================

  static const List<String> statuses = [
    'all',
    'open',
    'full',
    'running',
    'completed',
    'cancelled',
  ];

  // =========================================================
  // STATUS LABEL
  // =========================================================

  String _getLabel(
    String status,
  ) {
    switch (status) {
      case 'all':
        return 'Tất cả';

      case 'open':
        return 'Đang mở';

      case 'full':
        return 'Đã đầy';

      case 'running':
        return 'Đang diễn ra';

      case 'completed':
        return 'Đã hoàn thành';

      case 'cancelled':
        return 'Đã hủy';

      default:
        return status;
    }
  }

  // =========================================================
  // STATUS ICON
  // =========================================================

  IconData _getIcon(
    String status,
  ) {
    switch (status) {
      case 'all':
        return Icons.list_alt_outlined;

      case 'open':
        return Icons.lock_open_outlined;

      case 'full':
        return Icons.group_outlined;

      case 'running':
        return Icons.play_circle_outline;

      case 'completed':
        return Icons.check_circle_outline;

      case 'cancelled':
        return Icons.cancel_outlined;

      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      height: 48,

      child: ListView.separated(
        scrollDirection:
            Axis.horizontal,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        itemCount:
            statuses.length,

        separatorBuilder:
            (_, __) =>
                const SizedBox(
          width: 8,
        ),

        itemBuilder:
            (context, index) {
          final status =
              statuses[index];

          final bool isSelected =
              selectedStatus ==
                  status;

          return ChoiceChip(
            selected:
                isSelected,

            onSelected:
                (_) {
              onChanged(
                status,
              );
            },

            avatar:
                Icon(
              _getIcon(
                status,
              ),
              size: 18,
              color: isSelected
                  ? Colors.white
                  : Colors.grey.shade700,
            ),

            label:
                Text(
              _getLabel(
                status,
              ),
            ),

            selectedColor:
                Colors.green,

            backgroundColor:
                Colors.grey.shade100,

            side:
                BorderSide.none,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            labelStyle:
                TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black87,

              fontWeight:
                  FontWeight.w600,

              fontSize: 13,
            ),

            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          );
        },
      ),
    );
  }
}

