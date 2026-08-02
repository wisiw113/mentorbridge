import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/appointment_rating_model.dart';
import 'mentor_review_card.dart';

class MentorReviewList extends StatefulWidget {
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
  State<MentorReviewList> createState() =>
      _MentorReviewListState();
}

class _MentorReviewListState
    extends State<MentorReviewList> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =========================================================
  // CACHE USER INFO
  // =========================================================

  final Map<String, Map<String, dynamic>>
      _reviewerCache = {};

  bool _isLoadingReviewers = false;

  @override
  void initState() {
    super.initState();
    _loadReviewerInfo();
  }

  @override
  void didUpdateWidget(
    covariant MentorReviewList oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.reviews != widget.reviews) {
      _loadReviewerInfo();
    }
  }

  // =========================================================
  // LOAD REVIEWER INFO
  // =========================================================

  Future<void> _loadReviewerInfo() async {
    if (widget.reviews.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingReviewers = true;
      });
    }

    // Chỉ lấy những review đang hiển thị
    final visibleReviews = widget.reviews
        .take(widget.maxVisibleReviews)
        .toList();

    // Lấy danh sách menteeId duy nhất
    final menteeIds = visibleReviews
        .map((review) => review.menteeId)
        .where((id) => id.isNotEmpty)
        .toSet();

    try {
      for (final menteeId in menteeIds) {
        // Nếu đã có trong cache thì không query lại
        if (_reviewerCache.containsKey(menteeId)) {
          continue;
        }

        final userDoc = await _firestore
            .collection('users')
            .doc(menteeId)
            .get();

        if (userDoc.exists &&
            userDoc.data() != null) {
          final data = userDoc.data()!;

          _reviewerCache[menteeId] = {
            'name':
                (data['name'] ?? '').toString(),

            'email':
                (data['email'] ?? '').toString(),

            'photoURL':
                data['photoURL']?.toString(),
          };
        } else {
          // Nếu không tìm thấy user
          _reviewerCache[menteeId] = {
            'name': '',
            'email': '',
            'photoURL': null,
          };
        }
      }
    } catch (e) {
      debugPrint(
        'Error loading reviewer information: $e',
      );
    }

    if (!mounted) return;

    setState(() {
      _isLoadingReviewers = false;
    });
  }

  // =========================================================
  // GET REVIEWER NAME
  // =========================================================

  String _getReviewerName(
    AppointmentRatingModel review,
  ) {
    final userData =
        _reviewerCache[review.menteeId];

    // Ưu tiên tên lấy từ users
    final name =
        userData?['name']?.toString() ?? '';

    if (name.trim().isNotEmpty) {
      return name;
    }

    // Nếu không lấy được thì dùng tên được lưu
    // trong AppointmentRatingModel
    if (review.menteeName.trim().isNotEmpty) {
      return review.menteeName;
    }

    return 'Anonymous';
  }

  // =========================================================
  // GET REVIEWER EMAIL
  // =========================================================

  String _getReviewerEmail(
    AppointmentRatingModel review,
  ) {
    final userData =
        _reviewerCache[review.menteeId];

    return userData?['email']?.toString() ?? '';
  }

  // =========================================================
  // GET REVIEWER AVATAR
  // =========================================================

  String? _getReviewerAvatar(
    AppointmentRatingModel review,
  ) {
    final userData =
        _reviewerCache[review.menteeId];

    final photoURL =
        userData?['photoURL']?.toString();

    if (photoURL != null &&
        photoURL.trim().isNotEmpty) {
      return photoURL;
    }

    return null;
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    // =====================================================
    // LOADING RATING
    // =====================================================

    if (widget.isLoading) {
      return _buildLoadingState();
    }

    // =====================================================
    // VISIBLE REVIEWS
    // =====================================================

    final visibleReviews = widget.reviews
        .take(widget.maxVisibleReviews)
        .toList();

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
            color:
                Colors.black.withOpacity(.04),
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
                      "${widget.reviews.length} review${widget.reviews.length > 1 ? 's' : ''}",
                      style:
                          const TextStyle(
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

          if (widget.reviews.isEmpty)
            _buildEmptyState(),

          // =================================================
          // REVIEW LIST
          // =================================================

          if (widget.reviews.isNotEmpty)
            ...visibleReviews.map(
              (review) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: MentorReviewCard(
                    // Tên:
                    // Lấy từ users/{menteeId}
                    // Nếu không có thì dùng menteeName
                    reviewerName:
                        _getReviewerName(
                      review,
                    ),

                    // Email:
                    // Lấy trực tiếp từ users/{menteeId}
                    reviewerEmail:
                        _getReviewerEmail(
                      review,
                    ),

                    // Avatar:
                    // Lấy photoURL từ users/{menteeId}
                    reviewerAvatarUrl:
                        _getReviewerAvatar(
                      review,
                    ),

                    // Rating
                    rating:
                        review.rating,

                    // Comment
                    comment:
                        review.comment,

                    // Review type
                    reviewType:
                        "Appointment",

                    // Created date
                    createdAt:
                        review.createdAt,
                  ),
                );
              },
            ),

          // =================================================
          // LOADING REVIEWER INFO
          // =================================================

          if (_isLoadingReviewers &&
              widget.reviews.isNotEmpty)
            const Padding(
              padding:
                  EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                        AppColors.deepGreen,
                  ),
                ),
              ),
            ),

          // =================================================
          // VIEW ALL
          // =================================================

          if (widget.reviews.length >
              widget.maxVisibleReviews)
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
            offset:
                const Offset(0, 4),
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
        onPressed:
            widget.onViewAll,
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