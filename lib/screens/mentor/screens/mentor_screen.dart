import 'package:flutter/material.dart';

import '../tabs/home_tab.dart';
import '../tabs/schedule_tab.dart';
import '../tabs/activity_tab.dart';

// Shared
import '../../common/profile_tab.dart';
import '../../common/notification_screen.dart';

// Custom bottom navbar
import '../../../widgets/common/custom_bottom_navbar.dart';

// Floating chat button
import '../../../widgets/chat/floating_chat_button.dart';

// Notification
import '../../../widgets/notification/notification_bell.dart';

// Chat
import '../../../screens/chat/chat_list_screen.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({
    super.key,
  });

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
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
          isMentor: true,
        ),
      ),
    );
  }

  // =========================================================
  // OPEN NOTIFICATION SCREEN
  // =========================================================

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // NOTIFICATION BELL
          // ===================================================

          Positioned(
            right: 20,
            bottom: 160,
            child: NotificationBell(
              onTap: _openNotifications,
            ),
          ),

          // ===================================================
          // FLOATING CHAT BUTTON
          // ===================================================

          Positioned(
            right: 20,
            bottom: 95,
            child: FloatingChatButton(
              onPressed: _openChat,
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