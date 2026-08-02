
import 'package:flutter/material.dart';

import '../tabs/home_tab.dart';
import '../tabs/schedule_tab.dart';
import '../tabs/activity_tab.dart';

// Shared
import '../../common/profile_tab.dart';

// Custom bottom navbar
import '../../../widgets/common/custom_bottom_navbar.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

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

