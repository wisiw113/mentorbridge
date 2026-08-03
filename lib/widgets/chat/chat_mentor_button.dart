import 'package:flutter/material.dart';

class ChatMentorButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ChatMentorButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          height: 44,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color:
                const Color(0xFFE8F5E9),
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color:
                  const Color(0xFFA5D6A7),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons
                    .chat_bubble_outline_rounded,
                size: 18,
                color:
                    Color(0xFF2E7D32),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                'Chat',
                style: TextStyle(
                  color:
                      Color(0xFF2E7D32),
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}