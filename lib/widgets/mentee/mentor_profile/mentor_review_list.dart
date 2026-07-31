import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/appointment_rating_model.dart';
import 'mentor_review_card.dart';

class MentorReviewList extends StatelessWidget {
  final List<AppointmentRatingModel> reviews;

  final bool isLoading;

  final VoidCallback? onViewAll;

  /// Số review tối đa hiển thị trên Mentor Profile
  final int maxVisibleReviews;

  const MentorReviewList({
    super.key,
    required this.reviews,
    this.isLoading = false,
    this.onViewAll,
    this.maxVisibleReviews = 3,
  });

  @override
  Widget build(BuildContext context) {
    // =====================================================
    // LOADING
    // =====================================================

    if (isLoading) {
      return _buildLoadingState();
    }

    // =====================================================
    // VISIBLE REVIEWS
    // =====================================================

    final visibleReviews =
        reviews.take(maxVisibleReviews).toList();

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
          // =================================================
          // HEADER
          // =================================================

          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen
                      .withOpacity(.12),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.rate_review_outlined,
                  color:
                      AppColors.deepGreen,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reviews",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "${reviews.length} review${reviews.length > 1 ? 's' : ''}",
                      style: const TextStyle(
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

          const SizedBox(height: 20),

          // =================================================
          // EMPTY
          // =================================================

          if (reviews.isEmpty)
            _buildEmptyState(),

          // =================================================
          // REVIEW LIST
          // =================================================

          if (reviews.isNotEmpty)
            ...visibleReviews.map(
              (review) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: MentorReviewCard(
                    reviewerName:
                        review.menteeName,
                    reviewerAvatarUrl:
                        null,
                    rating:
                        review.rating,
                    comment:
                        review.comment,
                    reviewType:
                        "Appointment",
                    createdAt:
                        review.createdAt,
                  ),
                );
              },
            ),

          // =================================================
          // VIEW ALL
          // =================================================

          if (reviews.length >
              maxVisibleReviews)
            _buildViewAllButton(),
        ],
      ),
    );
  }

  // =========================================================
  // LOADING
  // =========================================================

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding:
          const EdgeInsets.symmetric(
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color:
                  AppColors.deepGreen,
            ),
            SizedBox(height: 15),
            Text(
              "Đang tải đánh giá...",
              style: TextStyle(
                color:
                    AppColors.gray,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY
  // =========================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: AppColors.softMint
            .withOpacity(.35),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 42,
            color: AppColors.gray,
          ),
          SizedBox(height: 10),
          Text(
            "Chưa có đánh giá nào",
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.darkGray,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Mentor chưa nhận được đánh giá.",
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color:
                  AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // VIEW ALL
  // =========================================================

  Widget _buildViewAllButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onViewAll,
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              AppColors.deepGreen,
          side: const BorderSide(
            color:
                AppColors.deepGreen,
          ),
          padding:
              const EdgeInsets.symmetric(
            vertical: 12,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
        ),
        child: const Text(
          "View all reviews",
          style: TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }
}