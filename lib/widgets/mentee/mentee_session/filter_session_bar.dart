
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FilterSessionBar extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onChanged;

  const FilterSessionBar({
    super.key,
    required this.selectedSort,
    required this.onChanged,
  });

  // =========================================================
  // CÁC LỰA CHỌN SẮP XẾP
  // =========================================================

  static const List<String> sortOptions = [
    'nearest',
    'farthest',
  ];

  // =========================================================
  // NHÃN HIỂN THỊ
  // =========================================================

  String _getLabel(String sort) {
    switch (sort) {
      case 'nearest':
        return 'Gần nhất';

      case 'farthest':
        return 'Xa nhất';

      default:
        return 'Gần nhất';
    }
  }

  // =========================================================
  // BIỂU TƯỢNG
  // =========================================================

  IconData _getIcon(String sort) {
    switch (sort) {
      case 'nearest':
        return Icons.near_me_outlined;

      case 'farthest':
        return Icons.swap_vert;

      default:
        return Icons.sort;
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.sort,
            size: 20,
            color: AppColors.deepGreen,
          ),

          const SizedBox(
            width: 8,
          ),

          const Text(
            'Sắp xếp:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortOptions.contains(
                    selectedSort,
                  )
                      ? selectedSort
                      : sortOptions.first,

                  isExpanded: true,

                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                  ),

                  borderRadius:
                      BorderRadius.circular(12),

                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    onChanged(value);
                  },

                  items: sortOptions.map(
                    (sort) {
                      return DropdownMenuItem<String>(
                        value: sort,
                        child: Row(
                          children: [
                            Icon(
                              _getIcon(sort),
                              size: 18,
                              color:
                                  AppColors.deepGreen,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Text(
                              _getLabel(sort),
                              style:
                                  const TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

