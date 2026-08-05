
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/admin/admin_logout_button.dart';

import 'tabs/admin_dashboard_tab.dart';
import 'tabs/admin_user_management_screen.dart';
import 'tabs/admin_session_management_screen.dart';
import 'tabs/profile_tab.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int currentIndex = 0;

  late final List<Widget> pages = const [
    AdminDashboardTab(),
    AdminUserManagementScreen(),
    AdminSessionManagementScreen(),
    ProfileTab(),
  ];

  final List<String> titles = const [
    'Admin Dashboard',
    'User Management',
    'Session Management',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        foregroundColor: AppColors.white,
        elevation: 0,

        title: Text(
          titles[currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: const [
          AdminLogoutButton(),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,

        backgroundColor: AppColors.white,

        selectedItemColor: AppColors.deepGreen,
        unselectedItemColor: AppColors.gray,

        elevation: 8,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups_rounded),
            label: 'Users',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note_rounded),
            label: 'Sessions',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

