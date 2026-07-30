import 'package:flutter/material.dart';

import '../tabs/home_tab.dart';
import '../tabs/search_tab.dart';
import '../tabs/activity_tab.dart';

// shared profile
import '../../common/profile_tab.dart';

class MenteeScreen extends StatefulWidget {
  const MenteeScreen({super.key});

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
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_bottom),
            label: "Status",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}