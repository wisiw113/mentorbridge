
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileStats extends StatelessWidget {
  final String role;
  final int? birthYear;
  final String gender;

  const ProfileStats({
    super.key,
    required this.role,
    required this.birthYear,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          title: "Role",
          value: role,
        ),
        _StatItem(
          title: "Birth Year",
          value: birthYear?.toString() ?? "-",
        ),
        _StatItem(
          title: "Gender",
          value: gender.isEmpty ? "-" : gender,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.deepGreen,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.gray,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

