
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/chat_service.dart';
import '../../widgets/chat/chat_screen/chat_app_bar.dart';
import '../../widgets/chat/chat_screen/chat_input.dart';
import '../../widgets/chat/chat_screen/chat_message_list.dart';

class ChatScreen extends StatefulWidget {
  final String mentorId;
  final String mentorName;
  final String? existingChatId;

  const ChatScreen({
    super.key,
    required this.mentorId,
    required this.mentorName,
    this.existingChatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // =========================================================
  // SERVICE
  // =========================================================

  final ChatService _chatService = ChatService();

  // =========================================================
  // CONTROLLERS
  // =========================================================

  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  // =========================================================
  // STATE
  // =========================================================

  String? _chatId;

  bool _isLoadingChat = true;

  bool _isSending = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    _chatId = widget.existingChatId;

    if (_chatId != null) {
      _isLoadingChat = false;
    } else {
      _loadExistingChat();
    }
  }

  // =========================================================
  // LOAD EXISTING CHAT
  // =========================================================

  Future<void> _loadExistingChat() async {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (!mounted) return;

      setState(() {
        _isLoadingChat = false;
      });

      return;
    }

    try {
      final chat = await _chatService.getChat(
        mentorId: widget.mentorId,
        menteeId: currentUser.uid,
      );

      if (!mounted) return;

      setState(() {
        _chatId = chat?.id;
        _isLoadingChat = false;
      });
    } catch (e) {
      debugPrint(
        'Load existing chat error: $e',
      );

      if (!mounted) return;

      setState(() {
        _isLoadingChat = false;
      });
    }
  }

  // =========================================================
  // SEND MESSAGE
  // =========================================================

  Future<void> _sendMessage() async {
    final message =
        _messageController.text.trim();

    if (message.isEmpty || _isSending) {
      return;
    }

    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            'Vui lòng đăng nhập để gửi tin nhắn.',
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
        ),
      );

      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final senderName =
          currentUser.displayName
                      ?.trim()
                      .isNotEmpty ==
                  true
              ? currentUser.displayName!.trim()
              : 'Mentee';

      // =====================================================
      // CREATE CHAT + FIRST MESSAGE
      // =====================================================

      if (_chatId == null) {
        final chat =
            await _chatService
                .createChatAndSendFirstMessage(
          mentorId: widget.mentorId,
          mentorName: widget.mentorName,
          menteeId: currentUser.uid,
          menteeName: senderName,
          message: message,
        );

        _chatId = chat.id;
      }

      // =====================================================
      // SEND MESSAGE
      // =====================================================

      else {
        await _chatService.sendMessage(
          chatId: _chatId!,
          senderId: currentUser.uid,
          senderName: senderName,
          message: message,
        );
      }

      _messageController.clear();

      if (!mounted) return;

      _scrollToBottom();
    } catch (e) {
      debugPrint(
        'Send message error: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            'Không thể gửi tin nhắn: $e',
            style: const TextStyle(
              color: AppColors.white,
            ),
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isSending = false;
      });
    }
  }

  // =========================================================
  // SCROLL TO BOTTOM
  // =========================================================

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (!_scrollController.hasClients) {
          return;
        }

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(
            milliseconds: 250,
          ),
          curve: Curves.easeOut,
        );
      },
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMint.withOpacity(
        0.15,
      ),

      appBar: ChatAppBar(
        mentorName: widget.mentorName,
      ),

      body: Column(
        children: [
          // ===================================================
          // CHAT CONTENT
          // ===================================================

          Expanded(
            child: _buildChatContent(),
          ),

          // ===================================================
          // INPUT
          // ===================================================

          ChatInput(
            controller: _messageController,
            isSending: _isSending,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CHAT CONTENT
  // =========================================================

  Widget _buildChatContent() {
    if (_isLoadingChat) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.mintGreen,
        ),
      );
    }

    if (_chatId == null) {
      return const SizedBox.shrink();
    }

    return ChatMessageList(
      chatId: _chatId!,
      mentorName: widget.mentorName,
      scrollController: _scrollController,
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }
}

