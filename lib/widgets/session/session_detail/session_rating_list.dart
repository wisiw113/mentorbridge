import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/session_rating_model.dart';

class SessionRatingList extends StatelessWidget {
  final List<SessionRatingModel> ratings;

  /// Hiển thị trạng thái loading
  final bool isLoading;

  /// Callback khi người dùng muốn xem tất cả đánh giá
  final VoidCallback? onViewAll;

  /// Số lượng review tối đa hiển thị
  final int maxVisibleRatings;

  const SessionRatingList({
    super.key,
    required this.ratings,
    this.isLoading = false,
    this.onViewAll,
    this.maxVisibleRatings = 3,
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
    // VISIBLE RATINGS
    // =====================================================

    final visibleRatings =
        ratings.take(maxVisibleRatings).toList();

    // =====================================================
    // MAIN CONTAINER
    // =====================================================

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
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

          _buildHeader(),

          const SizedBox(height: 20),

          // =================================================
          // EMPTY
          // =================================================

          if (ratings.isEmpty)
            _buildEmptyState(),

          // =================================================
          // RATINGS
          // =================================================

          if (ratings.isNotEmpty)
            ...visibleRatings.map(
              (rating) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 14,
                  ),
                  child:
                      _SessionRatingItem(
                    rating: rating,
                  ),
                );
              },
            ),

          // =================================================
          // VIEW ALL
          // =================================================

          if (ratings.length >
              maxVisibleRatings)
            _buildViewAllButton(),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    final averageRating =
        _calculateAverageRating();

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // ICON
        Container(
          padding:
              const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.mintGreen
                .withOpacity(.12),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.rate_review_outlined,
            color:
                AppColors.deepGreen,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        // TITLE + COUNT
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Session Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppColors.deepGreen,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${ratings.length} review${ratings.length > 1 ? 's' : ''}",
                style: const TextStyle(
                  fontSize: 13,
                  color:
                      AppColors.gray,
                ),
              ),
            ],
          ),
        ),

        // AVERAGE
        if (ratings.isNotEmpty)
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color:
                        Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    averageRating
                        .toStringAsFixed(1),
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.deepGreen,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              const Text(
                "Average",
                style: TextStyle(
                  fontSize: 11,
                  color:
                      AppColors.gray,
                ),
              ),
            ],
          ),
      ],
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
        vertical: 10,
      ),
      padding:
          const EdgeInsets.symmetric(
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Column(
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
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
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
            size: 45,
            color:
                AppColors.gray,
          ),

          SizedBox(height: 12),

          Text(
            "Chưa có đánh giá",
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.darkGray,
            ),
          ),

          SizedBox(height: 6),

          Text(
            "Session này chưa nhận được đánh giá nào từ Mentee.",
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
  // VIEW ALL BUTTON
  // =========================================================

  Widget _buildViewAllButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onViewAll,
        icon: const Icon(
          Icons.arrow_forward,
          size: 18,
        ),
        label: const Text(
          "Xem tất cả đánh giá",
        ),
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              AppColors.deepGreen,
          side:
              const BorderSide(
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
      ),
    );
  }

  // =========================================================
  // CALCULATE AVERAGE
  // =========================================================

  double _calculateAverageRating() {
    if (ratings.isEmpty) {
      return 0.0;
    }

    double total = 0;

    for (final rating in ratings) {
      total += rating.rating;
    }

    return total / ratings.length;
  }
}

// =============================================================
// SINGLE SESSION RATING ITEM
// =============================================================

class _SessionRatingItem
    extends StatelessWidget {
  final SessionRatingModel rating;

  const _SessionRatingItem({
    required this.rating,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            AppColors.softMint
                .withOpacity(.25),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              AppColors.border
                  .withOpacity(.5),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =================================================
          // USER INFO
          // =================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // AVATAR
              _buildAvatar(),

              const SizedBox(width: 12),

              // NAME + DATE
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.menteeName
                              .isNotEmpty
                          ? rating.menteeName
                          : "Mentee",
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppColors.darkGray,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      _formatDate(
                        rating.createdAt,
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
              ),

              // RATING
              _buildRating(),
            ],
          ),

          // =================================================
          // COMMENT
          // =================================================

          if (rating.comment
              .trim()
              .isNotEmpty) ...[
            const SizedBox(
              height: 12,
            ),

            Text(
              rating.comment.trim(),
              style:
                  const TextStyle(
                fontSize: 14,
                height: 1.5,
                color:
                    AppColors.darkGray,
              ),
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
    final name =
        rating.menteeName.trim();

    final initial =
        name.isNotEmpty
            ? name[0].toUpperCase()
            : "M";

    return Container(
      width: 44,
      height: 44,
      alignment:
          Alignment.center,
      decoration: BoxDecoration(
        color:
            AppColors.mintGreen
                .withOpacity(.2),
        shape:
            BoxShape.circle,
      ),
      child: Text(
        initial,
        style:
            const TextStyle(
          fontSize: 17,
          fontWeight:
              FontWeight.bold,
          color:
              AppColors.deepGreen,
        ),
      ),
    );
  }

  // =========================================================
  // RATING
  // =========================================================

  Widget _buildRating() {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        const Icon(
          Icons.star_rounded,
          color:
              Colors.amber,
          size: 19,
        ),

        const SizedBox(
          width: 3,
        ),

        Text(
          rating.rating
              .toStringAsFixed(1),
          style:
              const TextStyle(
            fontSize: 14,
            fontWeight:
                FontWeight.bold,
            color:
                AppColors.darkGray,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // FORMAT DATE
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

