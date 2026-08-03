import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/chat_model.dart';
import '../../services/chat_service.dart';
import '../../widgets/chat/chat_list_screen/chat_list_appbar.dart';
import '../../widgets/chat/chat_list_screen/chat_list_empty_state.dart';
import '../../widgets/chat/chat_list_screen/chat_list_error_state.dart';
import '../../widgets/chat/chat_list_screen/chat_list_item.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final bool isMentor;

  ChatListScreen({
    super.key,
    required this.isMentor,
  });

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // =====================================================
    // CHƯA ĐĂNG NHẬP
    // =====================================================

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Bạn chưa đăng nhập.',
          ),
        ),
      );
    }

    // =====================================================
    // CHAT STREAM
    // =====================================================

    final Stream<List<ChatModel>> chatStream =
        isMentor
            ? _chatService.getMentorChats(user.uid)
            : _chatService.getMenteeChats(user.uid);

    // =====================================================
    // SCREEN
    // =====================================================

    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: const ChatListAppBar(),

      body: Container(
        color: const Color(0xFFF5FBF7),

        child: StreamBuilder<List<ChatModel>>(
          stream: chatStream,

          builder: (context, snapshot) {
            // =================================================
            // LOADING
            // =================================================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // =================================================
            // ERROR
            // =================================================

            if (snapshot.hasError) {
              return ChatListErrorState(
                error: snapshot.error,
              );
            }

            // =================================================
            // DATA
            // =================================================

            final chats = snapshot.data ?? [];

            // =================================================
            // EMPTY
            // =================================================

            if (chats.isEmpty) {
              return const ChatListEmptyState();
            }

            // =================================================
            // CHAT LIST
            // =================================================

            return ListView.separated(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 20,
              ),

              itemCount: chats.length,

              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  indent: 84,
                  endIndent: 16,
                );
              },

              itemBuilder: (context, index) {
                final chat = chats[index];

                return ChatListItem(
                  chat: chat,
                  isMentor: isMentor,

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          mentorId: chat.mentorId,
                          mentorName: chat.mentorName,
                          existingChatId: chat.id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

