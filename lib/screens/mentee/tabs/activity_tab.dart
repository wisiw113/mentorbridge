import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

import 'pending_tab.dart';
import 'mentee_session_tab.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
            title: const Text(
              "Activity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.deepGreen,
            elevation: 0,

            bottom: const TabBar(
              labelColor: AppColors.deepGreen,
              unselectedLabelColor: AppColors.gray,
              indicatorColor: AppColors.mintGreen,
              tabs: [
                Tab(
                  text: "My appointments",
                ),
                Tab(
                  text: "My Sessions",
                ),
              ],
            ),
          ),

          body: const SafeArea(
            top: false,
            child: TabBarView(
              children: [
                PendingTab(),
                MenteeSessionTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}