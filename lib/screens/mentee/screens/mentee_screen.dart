import 'package:flutter/material.dart';

import '../tabs/home_tab.dart';
import '../tabs/search_tab.dart';
import '../tabs/activity_tab.dart';

import '../../common/profile_tab.dart';

import '../../../widgets/common/custom_bottom_navbar.dart';
import '../../../widgets/chat/floating_chat_button.dart';
import '../../../widgets/notification/notification_bell.dart';

import '../../common/notification_screen.dart';
import '../../chat/chat_list_screen.dart';

class MenteeScreen extends StatefulWidget {
  const MenteeScreen({
    super.key,
  });

  @override
  State<MenteeScreen> createState() => _MenteeScreenState();
}

class _MenteeScreenState extends State<MenteeScreen> {
  int currentIndex = 0;

  late final List<Widget> pages = [
    HomeTab(),
    SearchTab(),
    ActivityScreen(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ==========================================
          // CONTENT
          // ==========================================

          Positioned.fill(
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),

          // ==========================================
          // NOTIFICATION BELL
          // ==========================================

          Positioned(
            right: 20,
            bottom: 160,
            child: NotificationBell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NotificationScreen(),
                  ),
                );
              },
            ),
          ),

          // ==========================================
          // FLOATING CHAT BUTTON
          // ==========================================

          Positioned(
            right: 20,
            bottom: 95,
            child: FloatingChatButton(
              unreadCount: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatListScreen(
                      isMentor: false,
                    ),
                  ),
                );
              },
            ),
          ),

          // ==========================================
          // FLOATING NAVBAR
          // ==========================================

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