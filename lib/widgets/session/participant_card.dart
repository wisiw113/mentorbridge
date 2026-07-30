import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ParticipantCard extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? joinedAt;

  final VoidCallback? onTap;

  const ParticipantCard({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.joinedAt,
    this.onTap,
  });

  String formatDate(DateTime? date) {
    if (date == null) return "-";

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 3,
      shadowColor: AppColors.deepGreen.withOpacity(.08),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.lightMint,
          backgroundImage:
              avatarUrl != null && avatarUrl!.isNotEmpty
                  ? NetworkImage(avatarUrl!)
                  : null,
          child: avatarUrl == null || avatarUrl!.isEmpty
              ? const Icon(
                  Icons.person,
                  color: AppColors.deepGreen,
                )
              : null,
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.deepGreen,
            fontSize: 16,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              email,
              style: const TextStyle(
                color: AppColors.gray,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.mintGreen,
                ),

                const SizedBox(width: 5),

                Text(
                  "Joined: ${formatDate(joinedAt)}",
                  style: const TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),

        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.mintGreen,
        ),
      ),
    );
  }
}