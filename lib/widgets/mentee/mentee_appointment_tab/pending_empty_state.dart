import 'package:flutter/material.dart';

class PendingEmptyState extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback? onClearFilter;

  const PendingEmptyState({
    super.key,
    this.isFiltered = false,
    this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            // =================================================
            // ICON
            // =================================================

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFiltered
                    ? Icons.search_off_rounded
                    : Icons.pending_actions_outlined,
                size: 50,
                color: Colors.green,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // =================================================
            // TITLE
            // =================================================

            Text(
              isFiltered
                  ? 'Không tìm thấy kết quả'
                  : 'Chưa có yêu cầu nào',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // =================================================
            // DESCRIPTION
            // =================================================

            Text(
              isFiltered
                  ? 'Không có yêu cầu nào phù hợp với tìm kiếm hoặc bộ lọc hiện tại.'
                  : 'Hiện tại chưa có yêu cầu tham gia Session nào đang chờ xử lý.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            // =================================================
            // CLEAR FILTER BUTTON
            // =================================================

            if (isFiltered &&
                onClearFilter != null) ...[
              const SizedBox(
                height: 20,
              ),

              OutlinedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(
                  Icons.filter_alt_off_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Xóa bộ lọc',
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      Colors.green,
                  side: const BorderSide(
                    color: Colors.green,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

