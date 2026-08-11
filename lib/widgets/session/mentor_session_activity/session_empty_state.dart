import 'package:flutter/material.dart';

class SessionEmptyState extends StatelessWidget {
  const SessionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 16),

            const Text(
              'Chưa có khóa học nào',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Tạo khóa học đầu tiên của bạn để bắt đầu\nhuấn luyện học viên của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}