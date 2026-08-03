
import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';
import '/../models/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 280,
        ),

        margin: const EdgeInsets.only(
          bottom: 10,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),

        decoration: BoxDecoration(
          color: isMe
              ? AppColors.mintGreen
              : AppColors.white,

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),

            bottomLeft: Radius.circular(
              isMe ? 18 : 5,
            ),

            bottomRight: Radius.circular(
              isMe ? 5 : 18,
            ),
          ),

          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),

        child: Text(
          message.message,

          style: TextStyle(
            color: isMe
                ? AppColors.white
                : AppColors.darkGray,

            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

