import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_model.dart';
import '../models/chat_message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =========================================================
  // GET CHAT ID
  // =========================================================
  // Mentor + Mentee luôn có cùng một chatId.
  //
  // Ví dụ:
  // mentorId = "mentor123"
  // menteeId = "mentee456"
  //
  // => chatId = "mentor123_mentee456"
  //
  // Nếu đổi thứ tự mentor/mentee thì ID vẫn giống nhau.

  String getChatId({
    required String mentorId,
    required String menteeId,
  }) {
    final ids = [
      mentorId,
      menteeId,
    ]..sort();

    return '${ids[0]}_${ids[1]}';
  }

  // =========================================================
  // GET EXISTING CHAT
  // =========================================================
  // Dùng khi mở ChatScreen.
  //
  // Nếu chat chưa tồn tại:
  // return null
  //
  // Nếu chat đã tồn tại:
  // return ChatModel

  Future<ChatModel?> getChat({
    required String mentorId,
    required String menteeId,
  }) async {
    final chatId = getChatId(
      mentorId: mentorId,
      menteeId: menteeId,
    );

    final chatRef = _firestore
        .collection('chats')
        .doc(chatId);

    final snapshot =
        await chatRef.get();

    // Chat chưa tồn tại
    if (!snapshot.exists) {
      return null;
    }

    final data =
        snapshot.data();

    if (data == null) {
      return null;
    }

    return ChatModel.fromMap(
      snapshot.id,
      data,
    );
  }

  // =========================================================
  // CREATE CHAT + SEND FIRST MESSAGE
  // =========================================================
  // Đây là hàm quan trọng nhất.
  //
  // Khi Mentee mở ChatScreen:
  //
  //     Chưa tạo chat
  //
  // Khi Mentee gửi tin đầu tiên:
  //
  //     Tạo chats/{chatId}
  //     +
  //     Tạo chats/{chatId}/messages/{messageId}
  //
  // Hai thao tác được thực hiện bằng Batch.
  //
  // Nếu một thao tác lỗi thì toàn bộ Batch không được commit.

  Future<ChatModel>
      createChatAndSendFirstMessage({
    required String mentorId,
    required String mentorName,
    required String menteeId,
    required String menteeName,
    required String message,
  }) async {
    final trimmedMessage =
        message.trim();

    // Không cho gửi tin rỗng
    if (trimmedMessage.isEmpty) {
      throw Exception(
        'Message cannot be empty.',
      );
    }

    // =======================================================
    // GET CHAT ID
    // =======================================================

    final chatId =
        getChatId(
      mentorId: mentorId,
      menteeId: menteeId,
    );

    // =======================================================
    // CHAT REFERENCE
    // =======================================================

    final chatRef = _firestore
        .collection('chats')
        .doc(chatId);

    // =======================================================
    // MESSAGE REFERENCE
    // =======================================================

    final messageRef = chatRef
        .collection('messages')
        .doc();

    // =======================================================
    // CURRENT TIME
    // =======================================================

    final now =
        DateTime.now();

    // =======================================================
    // CREATE CHAT MODEL
    // =======================================================

    final chat = ChatModel(
      id: chatId,

      mentorId: mentorId,
      mentorName: mentorName,

      menteeId: menteeId,
      menteeName: menteeName,

      lastMessage:
          trimmedMessage,

      lastMessageAt: now,

      createdAt: now,
    );

    // =======================================================
    // CREATE FIRST MESSAGE MODEL
    // =======================================================

    final chatMessage =
        ChatMessageModel(
      id: messageRef.id,

      chatId: chatId,

      senderId: menteeId,

      senderName:
          menteeName,

      message:
          trimmedMessage,

      createdAt: now,
    );

    // =======================================================
    // CREATE BATCH
    // =======================================================

    final batch =
        _firestore.batch();

    // =======================================================
    // 1. CREATE CHAT
    // =======================================================

    batch.set(
      chatRef,
      chat.toMap(),
    );

    // =======================================================
    // 2. CREATE FIRST MESSAGE
    // =======================================================

    batch.set(
      messageRef,
      chatMessage.toMap(),
    );

    // =======================================================
    // COMMIT
    // =======================================================

    await batch.commit();

    // =======================================================
    // RETURN CHAT
    // =======================================================

    return chat;
  }

  // =========================================================
  // GET OR CREATE CHAT
  // =========================================================
  // Hàm này dùng trong trường hợp bạn muốn chủ động tạo chat.
  //
  // Tuy nhiên với flow hiện tại:
  //
  //     Mentor Profile
  //          ↓
  //     ChatScreen
  //          ↓
  //     Gửi tin đầu tiên
  //
  // Bạn KHÔNG cần gọi hàm này khi chỉ bấm Chat.
  //
  // Có thể giữ lại để sử dụng cho những trường hợp khác.

  Future<ChatModel> getOrCreateChat({
    required String mentorId,
    required String mentorName,
    required String menteeId,
    required String menteeName,
  }) async {
    final chatId =
        getChatId(
      mentorId: mentorId,
      menteeId: menteeId,
    );

    final chatRef = _firestore
        .collection('chats')
        .doc(chatId);

    // Kiểm tra chat đã tồn tại chưa

    final snapshot =
        await chatRef.get();

    // =======================================================
    // CHAT ĐÃ TỒN TẠI
    // =======================================================

    if (snapshot.exists) {
      final data =
          snapshot.data();

      if (data == null) {
        throw Exception(
          'Chat data is empty.',
        );
      }

      return ChatModel.fromMap(
        snapshot.id,
        data,
      );
    }

    // =======================================================
    // CHAT CHƯA TỒN TẠI
    // =======================================================

    final now =
        DateTime.now();

    final chat = ChatModel(
      id: chatId,

      mentorId: mentorId,
      mentorName: mentorName,

      menteeId: menteeId,
      menteeName: menteeName,

      lastMessage: '',

      lastMessageAt: now,

      createdAt: now,
    );

    await chatRef.set(
      chat.toMap(),
    );

    return chat;
  }

  // =========================================================
  // GET MENTOR CHATS
  // =========================================================
  // Lấy danh sách tất cả chat của Mentor.
  //
  // Dùng trong:
  //
  // ChatListScreen(isMentor: true)

  Stream<List<ChatModel>>
      getMentorChats(
    String mentorId,
  ) {
    return _firestore
        .collection('chats')
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .orderBy(
          'lastMessageAt',
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  ChatModel.fromMap(
                doc.id,
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  // =========================================================
  // GET MENTEE CHATS
  // =========================================================
  // Lấy danh sách tất cả chat của Mentee.
  //
  // Dùng trong:
  //
  // ChatListScreen(isMentor: false)

  Stream<List<ChatModel>>
      getMenteeChats(
    String menteeId,
  ) {
    return _firestore
        .collection('chats')
        .where(
          'menteeId',
          isEqualTo: menteeId,
        )
        .orderBy(
          'lastMessageAt',
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  ChatModel.fromMap(
                doc.id,
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  // =========================================================
  // SEND MESSAGE
  // =========================================================
  // Dùng khi chat đã tồn tại.
  //
  // ChatScreen:
  //
  //     _chatId != null
  //           ↓
  //     sendMessage()
  //
  // Hàm này:
  //
  // 1. Tạo message mới
  // 2. Update lastMessage
  // 3. Update lastMessageAt
  //
  // Tất cả thực hiện bằng Batch.

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
  }) async {
    final trimmedMessage =
        message.trim();

    // Không gửi tin rỗng

    if (trimmedMessage.isEmpty) {
      return;
    }

    // =======================================================
    // CHAT REFERENCE
    // =======================================================

    final chatRef = _firestore
        .collection('chats')
        .doc(chatId);

    // =======================================================
    // KIỂM TRA CHAT
    // =======================================================

    final chatSnapshot =
        await chatRef.get();

    if (!chatSnapshot.exists) {
      throw Exception(
        'Chat does not exist.',
      );
    }

    // =======================================================
    // MESSAGE REFERENCE
    // =======================================================

    final messageRef = chatRef
        .collection('messages')
        .doc();

    // =======================================================
    // CURRENT TIME
    // =======================================================

    final now =
        DateTime.now();

    // =======================================================
    // CREATE MESSAGE MODEL
    // =======================================================

    final chatMessage =
        ChatMessageModel(
      id: messageRef.id,

      chatId: chatId,

      senderId: senderId,

      senderName:
          senderName,

      message:
          trimmedMessage,

      createdAt: now,
    );

    // =======================================================
    // CREATE BATCH
    // =======================================================

    final batch =
        _firestore.batch();

    // =======================================================
    // CREATE MESSAGE
    // =======================================================

    batch.set(
      messageRef,
      chatMessage.toMap(),
    );

    // =======================================================
    // UPDATE CHAT PREVIEW
    // =======================================================

    batch.update(
      chatRef,
      {
        'lastMessage':
            trimmedMessage,

        'lastMessageAt':
            Timestamp.fromDate(
          now,
        ),
      },
    );

    // =======================================================
    // COMMIT
    // =======================================================

    await batch.commit();
  }

  // =========================================================
  // GET MESSAGES
  // =========================================================
  // Lấy toàn bộ tin nhắn trong một cuộc trò chuyện.
  //
  // Dùng trong ChatScreen.

  Stream<List<ChatMessageModel>>
      getMessages(
    String chatId,
  ) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy(
          'createdAt',
          descending: false,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  ChatMessageModel.fromMap(
                doc.id,
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  // =========================================================
  // DELETE MESSAGE
  // =========================================================
  // Chỉ xóa một tin nhắn.
  //
  // Firestore Rules sẽ quyết định
  // người dùng có quyền xóa hay không.

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    final messageRef =
        _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(messageId);

    await messageRef.delete();
  }
}