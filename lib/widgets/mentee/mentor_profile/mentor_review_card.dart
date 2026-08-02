import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class MentorReviewCard extends StatelessWidget {
  final String reviewerName;
  final String reviewerEmail;
  final String? reviewerAvatarUrl;
  final double rating;
  final String comment;
  final String reviewType;
  final DateTime? createdAt;

  const MentorReviewCard({
    super.key,
    required this.reviewerName,
    required this.reviewerEmail,
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
  color: Colors.black,
  width: 1.2,
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
          // HEADER
          // =================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // =================================================
              // AVATAR
              // =================================================

              _buildAvatar(),

              const SizedBox(width: 12),

              // =================================================
              // USER INFORMATION
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // NAME

                    Text(
                      reviewerName.trim().isNotEmpty
                          ? reviewerName.trim()
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

                    // EMAIL

                    if (reviewerEmail
                        .trim()
                        .isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 2,
                        ),
                        child: Text(
                          reviewerEmail.trim(),
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 11,
                            color:
                                AppColors.gray,
                          ),
                        ),
                      ),

                    const SizedBox(height: 5),

                    // RATING

                    Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        _buildStars(),

                        const SizedBox(width: 6),

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
            ],
          ),

          // =================================================
          // REVIEW TYPE
          // Để riêng bên dưới HEADER
          // Không còn bị tràn màn hình
          // =================================================

          const SizedBox(height: 10),

          _buildReviewType(),

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
                color:
                    AppColors.darkGray,
              ),
            )
          else
            Text(
              "Người dùng không để lại nhận xét.",
              style: TextStyle(
                fontSize: 14,
                fontStyle:
                    FontStyle.italic,
                color:
                    AppColors.gray,
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
                  color:
                      AppColors.gray,
                ),

                const SizedBox(width: 5),

                Text(
                  _formatDate(
                    createdAt!,
                  ),
                  style:
                      const TextStyle(
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
        reviewerAvatarUrl!
            .trim()
            .isNotEmpty;

    if (hasAvatar) {
      return CircleAvatar(
        radius: 24,
        backgroundColor:
            AppColors.softMint,
        backgroundImage:
            NetworkImage(
          reviewerAvatarUrl!.trim(),
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
    final double safeRating =
        rating.clamp(0.0, 5.0);

    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          final int starValue =
              index + 1;

          if (safeRating >=
              starValue) {
            return const Icon(
              Icons.star_rounded,
              size: 17,
              color:
                  Colors.amber,
            );
          }

          if (safeRating >=
              starValue - 0.5) {
            return const Icon(
              Icons.star_half_rounded,
              size: 17,
              color:
                  Colors.amber,
            );
          }

          return const Icon(
            Icons.star_border_rounded,
            size: 17,
            color:
                Colors.amber,
          );
        },
      ),
    );
  }

  // =========================================================
  // REVIEW TYPE
  // =========================================================

  Widget _buildReviewType() {
    final bool isAppointment =
        reviewType.toLowerCase() ==
            "appointment";

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration:
          BoxDecoration(
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
                ? Icons
                    .calendar_month_outlined
                : Icons
                    .groups_outlined,
            size: 14,
            color:
                AppColors.deepGreen,
          ),

          const SizedBox(width: 5),

          Text(
            isAppointment
                ? "Appointment"
                : "Session",
            style:
                const TextStyle(
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
    final String name =
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
    final String day =
        date.day
            .toString()
            .padLeft(2, "0");

    final String month =
        date.month
            .toString()
            .padLeft(2, "0");

    final String year =
        date.year.toString();

    return "$day/$month/$year";
  }
}