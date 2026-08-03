
import 'package:flutter/material.dart';

class ChatEmptyState extends StatelessWidget {
  final String mentorName;

  const ChatEmptyState({
    super.key,
    required this.mentorName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            // =================================================
            // ICON
            // =================================================

            Container(
              width: 76,
              height: 76,

              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: Color(0xFF66BB6A),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // TITLE
            // =================================================

            const Text(
              'Bắt đầu cuộc trò chuyện',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // =================================================
            // DESCRIPTION
            // =================================================

            Text(
              'Hãy gửi tin nhắn để bắt đầu\n'
              'trao đổi với $mentorName.',

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

