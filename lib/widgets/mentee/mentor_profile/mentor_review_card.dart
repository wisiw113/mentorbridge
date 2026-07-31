import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class MentorReviewCard extends StatelessWidget {
final String reviewerName;
final String? reviewerAvatarUrl;
final double rating;
final String comment;
final String reviewType;
final DateTime? createdAt;

const MentorReviewCard({
super.key,
required this.reviewerName,
this.reviewerAvatarUrl,
required this.rating,
required this.comment,
required this.reviewType,
this.createdAt,
});

@override
Widget build(BuildContext context) {
return Container(
width: double.infinity,
margin: const EdgeInsets.only(
bottom: 12,
),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(
color: AppColors.border.withOpacity(.5),
),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(.03),
blurRadius: 8,
offset: const Offset(0, 3),
),
],
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
// =================================================
// REVIEWER HEADER
// =================================================

 
      Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildAvatar(),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  reviewerName.isNotEmpty
                      ? reviewerName
                      : "Anonymous",
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppColors.darkGray,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    _buildStars(),

                    const SizedBox(width: 8),

                    Text(
                      rating.toStringAsFixed(1),
                      style:
                          const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          _buildReviewType(),
        ],
      ),

      const SizedBox(height: 14),

      // =================================================
      // COMMENT
      // =================================================

      if (comment.trim().isNotEmpty)
        Text(
          comment.trim(),
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.darkGray,
          ),
        )
      else
        Text(
          "Người dùng không để lại nhận xét.",
          style: TextStyle(
            fontSize: 14,
            fontStyle:
                FontStyle.italic,
            color: AppColors.gray,
          ),
        ),

      // =================================================
      // CREATED AT
      // =================================================

      if (createdAt != null) ...[
        const SizedBox(height: 12),

        Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              size: 15,
              color: AppColors.gray,
            ),

            const SizedBox(width: 5),

            Text(
              _formatDate(createdAt!),
              style: TextStyle(
                fontSize: 12,
                color:
                    AppColors.gray,
              ),
            ),
          ],
        ),
      ],
    ],
  ),
);
 

}

// =========================================================
// AVATAR
// =========================================================

Widget _buildAvatar() {
final hasAvatar =
reviewerAvatarUrl != null &&
reviewerAvatarUrl!.trim().isNotEmpty;

 
if (hasAvatar) {
  return CircleAvatar(
    radius: 24,
    backgroundColor:
        AppColors.softMint,
    backgroundImage:
        NetworkImage(
      reviewerAvatarUrl!,
    ),
  );
}

return CircleAvatar(
  radius: 24,
  backgroundColor:
      AppColors.softMint,
  child: Text(
    _getInitial(),
    style: const TextStyle(
      fontSize: 18,
      fontWeight:
          FontWeight.bold,
      color:
          AppColors.deepGreen,
    ),
  ),
);
 

}

// =========================================================
// STAR RATING
// =========================================================

Widget _buildStars() {
final safeRating =
rating.clamp(0.0, 5.0);

 
return Row(
  mainAxisSize:
      MainAxisSize.min,
  children: List.generate(
    5,
    (index) {
      final starValue =
          index + 1;

      if (safeRating >=
          starValue) {
        return const Icon(
          Icons.star_rounded,
          size: 17,
          color: Colors.amber,
        );
      }

      if (safeRating >=
          starValue - 0.5) {
        return const Icon(
          Icons.star_half_rounded,
          size: 17,
          color: Colors.amber,
        );
      }

      return const Icon(
        Icons
            .star_border_rounded,
        size: 17,
        color: Colors.amber,
      );
    },
  ),
);
 

}

// =========================================================
// REVIEW TYPE
// =========================================================

Widget _buildReviewType() {
final isAppointment =
reviewType.toLowerCase() ==
"appointment";

 
return Container(
  padding:
      const EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 5,
  ),
  decoration: BoxDecoration(
    color:
        AppColors.softMint,
    borderRadius:
        BorderRadius.circular(
      20,
    ),
  ),
  child: Row(
    mainAxisSize:
        MainAxisSize.min,
    children: [
      Icon(
        isAppointment
            ? Icons.calendar_month_outlined
            : Icons.groups_outlined,
        size: 14,
        color:
            AppColors.deepGreen,
      ),

      const SizedBox(width: 4),

      Text(
        isAppointment
            ? "Appointment"
            : "Session",
        style: const TextStyle(
          fontSize: 11,
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
// INITIAL
// =========================================================

String _getInitial() {
final name =
reviewerName.trim();

 
if (name.isEmpty) {
  return "?";
}

return name
    .substring(0, 1)
    .toUpperCase();
 

}

// =========================================================
// DATE FORMAT
// =========================================================

String _formatDate(
DateTime date,
) {
final day =
date.day
.toString()
.padLeft(2, "0");

 
final month =
    date.month
        .toString()
        .padLeft(2, "0");

final year =
    date.year.toString();

return "$day/$month/$year";
 

}
}
