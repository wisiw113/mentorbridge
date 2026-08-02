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
      child: Scaffold(
        backgroundColor: AppColors.lightMint,

        appBar: AppBar(
          title: const Text(
            "Activity",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),
          backgroundColor: AppColors.white,
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

            body: TabBarView(
        children: [
          PendingTab(),
          MenteeSessionTab(),
        ],
      ),
      ),
    );
  }
}