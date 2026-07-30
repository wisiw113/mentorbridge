import 'package:flutter/material.dart';

import 'admin_stat_card.dart';

class AdminStatsGrid extends StatelessWidget {
  final int totalUsers;
  final int mentors;
  final int mentees;
  final int pendingApproval;

  const AdminStatsGrid({
    super.key,
    required this.totalUsers,
    required this.mentors,
    required this.mentees,
    required this.pendingApproval,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        AdminStatCard(
          title: "Total Users",
          value: totalUsers.toString(),
          icon: Icons.people_outline,
        ),

        AdminStatCard(
          title: "Mentors",
          value: mentors.toString(),
          icon: Icons.school_outlined,
        ),

        AdminStatCard(
          title: "Mentees",
          value: mentees.toString(),
          icon: Icons.person_outline,
        ),

        AdminStatCard(
          title: "Pending Approval",
          value: pendingApproval.toString(),
          icon: Icons.pending_actions_outlined,
        ),
      ],
    );
  }
}