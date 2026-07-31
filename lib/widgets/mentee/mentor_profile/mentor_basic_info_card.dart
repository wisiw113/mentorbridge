import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class MentorBasicInfoCard extends StatelessWidget {
final String major;
final String studentYear;
final int? birthYear;

const MentorBasicInfoCard({
super.key,
required this.major,
required this.studentYear,
required this.birthYear,
});

@override
Widget build(BuildContext context) {
return Container(
width: double.infinity,
margin: const EdgeInsets.symmetric(
horizontal: 20,
),
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(.04),
blurRadius: 10,
offset: const Offset(0, 4),
),
],
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
// =========================
// TITLE
// =========================

 
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  AppColors.mintGreen.withOpacity(.12),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: AppColors.deepGreen,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          const Text(
            "Basic Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),
        ],
      ),

      const SizedBox(height: 20),

      // =========================
      // MAJOR
      // =========================

      _InfoRow(
        icon: Icons.menu_book_outlined,
        label: "Major",
        value: major,
      ),

      const SizedBox(height: 16),

      // =========================
      // STUDENT YEAR
      // =========================

      _InfoRow(
        icon: Icons.school_outlined,
        label: "Student Year",
        value: studentYear,
      ),

      const SizedBox(height: 16),

      // =========================
      // BIRTH YEAR
      // =========================

      _InfoRow(
        icon: Icons.cake_outlined,
        label: "Birth Year",
        value: birthYear != null
            ? birthYear.toString()
            : "Not provided",
      ),
    ],
  ),
);
 

}
}

// =========================================================
// INFO ROW
// =========================================================

class _InfoRow extends StatelessWidget {
final IconData icon;
final String label;
final String value;

const _InfoRow({
required this.icon,
required this.label,
required this.value,
});

@override
Widget build(BuildContext context) {
final hasValue =
value.trim().isNotEmpty;

 
return Row(
  crossAxisAlignment:
      CrossAxisAlignment.start,
  children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            AppColors.softMint,
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 20,
        color:
            AppColors.deepGreen,
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color:
                  AppColors.gray,
              fontWeight:
                  FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            hasValue
                ? value
                : "Not provided",
            style: const TextStyle(
              fontSize: 15,
              color:
                  AppColors.darkGray,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  ],
);
 

}
}
