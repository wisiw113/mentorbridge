import 'package:flutter/material.dart';

import 'admin_appointment_management_screen.dart';
import 'admin_session_management_screen.dart';

class AdminActivityManagementScreen extends StatelessWidget {
  const AdminActivityManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
  margin: const EdgeInsets.fromLTRB(
    16,
    12,
    16,
    0,
  ),
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(12),
  ),
  child: TabBar(
    dividerColor: Colors.transparent,
    indicator: BoxDecoration(
      color: const Color(0xFF10B981),
      borderRadius: BorderRadius.circular(10),
    ),
    indicatorSize: TabBarIndicatorSize.tab,

    labelColor: Colors.white,
    unselectedLabelColor: Colors.black87,

    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),

    unselectedLabelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),

    tabs: const [
      Tab(
        height: 40,
        iconMargin: EdgeInsets.only(bottom: 2),
        icon: Icon(
          Icons.event_note_outlined,
          size: 18,
        ),
        text: "Appointments",
      ),
      Tab(
        height: 40,
        iconMargin: EdgeInsets.only(bottom: 2),
        icon: Icon(
          Icons.groups_outlined,
          size: 18,
        ),
        text: "Sessions",
      ),
    ],
  ),
),
          const Expanded(
            child: TabBarView(
              children: [
                AdminAppointmentManagementScreen(),
                AdminSessionManagementScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}