import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SessionRatingSummaryCard extends StatelessWidget {
  final double averageRating;
  final int reviewCount;

  const SessionRatingSummaryCard({
    super.key,
    required this.averageRating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =================================================
          // HEADER
          // =================================================

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Session Ratings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Đánh giá từ các Mentee",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================================================
          // RATING SUMMARY
          // =================================================

          Row(
            children: [
              // =================================================
              // AVERAGE RATING
              // =================================================

              Expanded(
                child: Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) {
                          final starValue =
                              index + 1;

                          if (averageRating >=
                              starValue) {
                            return const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            );
                          }

                          if (averageRating >=
                              starValue - 0.5) {
                            return const Icon(
                              Icons.star_half_rounded,
                              color: Colors.amber,
                              size: 20,
                            );
                          }

                          return const Icon(
                            Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 20,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Điểm trung bình",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),

              // =================================================
              // DIVIDER
              // =================================================

              Container(
                width: 1,
                height: 80,
                color: Colors.grey.shade200,
              ),

              // =================================================
              // REVIEW COUNT
              // =================================================

              Expanded(
                child: Column(
                  children: [
                    Text(
                      reviewCount.toString(),
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Icon(
                      Icons.rate_review_outlined,
                      color: AppColors.deepGreen,
                      size: 22,
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Đánh giá",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // =================================================
          // EMPTY STATE
          // =================================================

          if (reviewCount == 0) ...[
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softMint
                    .withOpacity(0.35),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.gray,
                    size: 20,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Chưa có Mentee nào đánh giá các Session của bạn.",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

