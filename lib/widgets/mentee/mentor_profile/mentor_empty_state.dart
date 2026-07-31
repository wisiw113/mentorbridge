import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MentorEmptyState extends StatelessWidget {
final String title;
final String message;
final IconData icon;

const MentorEmptyState({
super.key,
required this.title,
required this.message,
this.icon = Icons.info_outline,
});

@override
Widget build(BuildContext context) {
return Container(
width: double.infinity,
margin: const EdgeInsets.symmetric(
horizontal: 20,
),
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 28,
),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: AppColors.border.withOpacity(.5),
),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(.04),
blurRadius: 10,
offset: const Offset(0, 4),
),
],
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
// =================================================
// ICON
// =================================================

 
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.softMint,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 32,
          color: AppColors.deepGreen,
        ),
      ),

      const SizedBox(height: 16),

      // =================================================
      // TITLE
      // =================================================

      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppColors.deepGreen,
        ),
      ),

      const SizedBox(height: 8),

      // =================================================
      // MESSAGE
      // =================================================

      Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.gray,
        ),
      ),
    ],
  ),
);
 

}
}
