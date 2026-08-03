import 'package:flutter/material.dart';

import '../tabs/home_tab.dart';
import '../tabs/schedule_tab.dart';
import '../tabs/activity_tab.dart';

// Shared
import '../../common/profile_tab.dart';

// Custom bottom navbar
import '../../../widgets/common/custom_bottom_navbar.dart';

// Floating chat button
import '../../../widgets/chat/floating_chat_button.dart';

// Chat
import '../../../screens/chat/chat_list_screen.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({
    super.key,
  });

  @override
  State<MentorScreen> createState() =>
      _MentorScreenState();
}

class _MentorScreenState
    extends State<MentorScreen> {

  int currentIndex = 0;

  late final List<Widget> pages = [
    HomeTab(),
    ActivityScreen(),
    ScheduleTab(),
    ProfileTab(),
  ];

  // =========================================================
  // OPEN CHAT LIST
  // =========================================================

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatListScreen(
          // Mentor xem danh sách chat của Mentor
          isMentor: true,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Stack(
        children: [

          // ===================================================
          // CONTENT
          // ===================================================

          Positioned.fill(
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),

          // ===================================================
          // FLOATING CHAT BUTTON
          // ===================================================

          Positioned(
            right: 20,
            bottom: 90,
            child: FloatingChatButton(
              onPressed: _openChat,

              // Sau này có thể truyền số tin nhắn chưa đọc
              unreadCount: 0,
            ),
          ),

          // ===================================================
          // FLOATING BOTTOM NAVBAR
          // ===================================================

          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: XBottomNavbar(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
} 