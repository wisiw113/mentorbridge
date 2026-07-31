import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class MentorSkillsCard extends StatelessWidget {
final List<String> skills;

const MentorSkillsCard({
super.key,
required this.skills,
});

@override
Widget build(BuildContext context) {
// =======================================================
// EMPTY STATE
// =======================================================

 
if (skills.isEmpty) {
  return _buildEmptyState();
}

// =======================================================
// SKILLS CARD
// =======================================================

return Container(
  width: double.infinity,
  margin:
      const EdgeInsets.symmetric(
    horizontal: 20,
  ),
  padding:
      const EdgeInsets.all(20),
  decoration:
      BoxDecoration(
    color:
        AppColors.white,
    borderRadius:
        BorderRadius.circular(
      20,
    ),
    border:
        Border.all(
      color:
          AppColors.border
              .withOpacity(.5),
    ),
    boxShadow: [
      BoxShadow(
        color:
            Colors.black.withOpacity(
          .04,
        ),
        blurRadius: 10,
        offset:
            const Offset(0, 4),
      ),
    ],
  ),
  child:
      Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [
      // =================================================
      // HEADER
      // =================================================

      Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(
              8,
            ),
            decoration:
                BoxDecoration(
              color:
                  AppColors.mintGreen
                      .withOpacity(
                .12,
              ),
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),
            child:
                const Icon(
              Icons
                  .auto_awesome_outlined,
              color:
                  AppColors.deepGreen,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          const Text(
            "Skills & Expertise",
            style:
                TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
              color:
                  AppColors.deepGreen,
            ),
          ),
        ],
      ),

      const SizedBox(
        height: 18,
      ),

      // =================================================
      // SKILLS
      // =================================================

      Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            skills.map(
          (skill) {
            return _buildSkillChip(
              skill,
            );
          },
        ).toList(),
      ),
    ],
  ),
);
 

}

// =========================================================
// SKILL CHIP
// =========================================================

Widget _buildSkillChip(
String skill,
) {
return Container(
padding:
const EdgeInsets.symmetric(
horizontal: 13,
vertical: 8,
),
decoration:
BoxDecoration(
color:
AppColors.softMint,
borderRadius:
BorderRadius.circular(
30,
),
border:
Border.all(
color:
AppColors.mintGreen
.withOpacity(
.35,
),
),
),
child:
Row(
mainAxisSize:
MainAxisSize.min,
children: [
const Icon(
Icons.check_circle_outline,
size: 16,
color:
AppColors.deepGreen,
),

 
      const SizedBox(
        width: 6,
      ),

      Text(
        skill,
        style:
            const TextStyle(
          fontSize: 13,
          fontWeight:
              FontWeight.w600,
          color:
              AppColors.deepGreen,
        ),
      ),
    ],
  ),
);
 

}

// =========================================================
// EMPTY STATE
// =========================================================

Widget _buildEmptyState() {
return Container(
width: double.infinity,
margin:
const EdgeInsets.symmetric(
horizontal: 20,
),
padding:
const EdgeInsets.all(
20,
),
decoration:
BoxDecoration(
color:
AppColors.white,
borderRadius:
BorderRadius.circular(
20,
),
border:
Border.all(
color:
AppColors.border
.withOpacity(.5),
),
),
child:
Row(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
const Icon(
Icons
.auto_awesome_outlined,
color:
AppColors.gray,
size: 24,
),

 
      const SizedBox(
        width: 12,
      ),

      Expanded(
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Skills & Expertise",
              style:
                  TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.darkGray,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              "Mentor chưa cập nhật thông tin kỹ năng.",
              style:
                  TextStyle(
                fontSize: 13,
                color:
                    AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
 

}
}
