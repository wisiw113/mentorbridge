import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';
import '/../models/chat_message_model.dart';
import '/../services/chat_service.dart';
import 'chat_empty_state.dart';
import 'chat_message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final String chatId;
  final String mentorName;
  final ScrollController scrollController;

  ChatMessageList({
    super.key,
    required this.chatId,
    required this.mentorName,
    required this.scrollController,
  });

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatMessageModel>>(
      stream: _chatService.getMessages(chatId),

      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.mintGreen,
            ),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Không thể tải tin nhắn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final messages = snapshot.data ?? [];

        // Empty
        if (messages.isEmpty) {
          return ChatEmptyState(
            mentorName: mentorName,
          );
        }

        // Current user
        final currentUser =
            FirebaseAuth.instance.currentUser;

        return ListView.builder(
          controller: scrollController,

          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),

          itemCount: messages.length,

          itemBuilder: (context, index) {
            final message = messages[index];

            final isMe =
                message.senderId == currentUser?.uid;

            return ChatMessageBubble(
              message: message,
              isMe: isMe,
            );
          },
        );
      },
    );
  }
}