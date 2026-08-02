import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';

import '../screens/requests_tab.dart';
import '../screens/session_tab.dart';

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
            'Activity',
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
                text: 'My Appointments',
              ),
              Tab(
                text: 'My Sessions',
              ),
            ],
          ),
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.lightMint,
          child: TabBarView(
            children: [
              const RequestsTab(),
              SessionTab(),
            ],
          ),
        ),
      ),
    );
  }
}