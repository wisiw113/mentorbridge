import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/appointment_rating_model.dart';
import '../../../models/session_model.dart';

import '../../../services/appointment_rating_service.dart';

import '../../../core/theme/app_colors.dart';

import '../../../widgets/chat/chat_mentor_button.dart';
import '../../../widgets/mentee/mentor_profile/mentor_about_card.dart';
import '../../../widgets/mentee/mentor_profile/mentor_basic_info_card.dart';
import '../../../widgets/mentee/mentor_profile/mentor_booking_button.dart';
import '../../../widgets/mentee/mentor_profile/mentor_empty_state.dart';
import '../../../widgets/mentee/mentor_profile/mentor_header.dart';
import '../../../widgets/mentee/mentor_profile/mentor_rating_card.dart';
import '../../../widgets/mentee/mentor_profile/mentor_review_list.dart';
import '../../../widgets/mentee/mentor_profile/mentor_session_list.dart';
import '../../../widgets/mentee/mentor_profile/mentor_skills_card.dart';

import '../../../screens/chat/chat_screen.dart';

import 'mentor_booking_screen.dart';
import 'mentee_session_detail_screen.dart';

class MentorProfileScreen
    extends StatelessWidget {
  final String mentorId;

  const MentorProfileScreen({
    super.key,
    required this.mentorId,
  });

  // =========================================================
  // GET MENTOR
  // =========================================================

  Stream<
      DocumentSnapshot<
          Map<String, dynamic>>> _mentorStream() {
    return FirebaseFirestore
        .instance
        .collection('users')
        .doc(mentorId)
        .snapshots();
  }

  // =========================================================
  // GET MENTOR SESSIONS
  // =========================================================

  Stream<List<SessionModel>>
      _mentorSessionsStream() {
    return FirebaseFirestore
        .instance
        .collection('sessions')
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .where(
          'status',
          isEqualTo: 'open',
        )
        .snapshots()
        .map(
      (snapshot) {
        final sessions =
            snapshot.docs
                .map(
                  (doc) =>
                      SessionModel.fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();

        // ===================================================
        // SORT SESSION BY DATE
        // ===================================================

        sessions.sort(
          (a, b) {
            final dateA =
                _parseSessionDateTime(
              a.date,
              a.startTime,
            );

            final dateB =
                _parseSessionDateTime(
              b.date,
              b.startTime,
            );

            return dateA.compareTo(
              dateB,
            );
          },
        );

        return sessions;
      },
    );
  }

  // =========================================================
  // PARSE SESSION DATE
  // =========================================================

  DateTime _parseSessionDateTime(
    String date,
    String time,
  ) {
    try {
      final dateParts =
          date.split('/');

      if (dateParts.length == 3) {
        final day =
            int.parse(
          dateParts[0],
        );

        final month =
            int.parse(
          dateParts[1],
        );

        final year =
            int.parse(
          dateParts[2],
        );

        final timeParts =
            time.split(':');

        final hour =
            timeParts.isNotEmpty
                ? int.tryParse(
                      timeParts[0],
                    ) ??
                    0
                : 0;

        final minute =
            timeParts.length > 1
                ? int.tryParse(
                      timeParts[1],
                    ) ??
                    0
                : 0;

        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
        );
      }
    } catch (_) {}

    return DateTime.now();
  }

  // =========================================================
  // OPEN CHAT
  // =========================================================
  //
  // QUAN TRỌNG:
  //
  // Không tạo chat ở đây.
  //
  // ChatScreen sẽ:
  //
  // 1. Kiểm tra chat đã tồn tại chưa.
  //
  // 2. Nếu có:
  //    Hiện lịch sử tin nhắn.
  //
  // 3. Nếu chưa có:
  //    Hiện màn hình "Bắt đầu cuộc trò chuyện".
  //
  // 4. Khi Mentee gửi tin đầu tiên:
  //    Tạo chat + message đầu tiên.
  //
  // =========================================================

  void _openChat({
    required BuildContext context,
    required String mentorName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatScreen(
          mentorId:
              mentorId,
          mentorName:
              mentorName,
        ),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.softMint,

      // =====================================================
      // BOTTOM ACTION BAR
      // CHAT + BOOKING
      // =====================================================

      bottomNavigationBar:
          StreamBuilder<
              DocumentSnapshot<
                  Map<String, dynamic>>>(
        stream:
            _mentorStream(),

        builder: (
          context,
          snapshot,
        ) {
          // =================================================
          // MENTOR NOT FOUND
          // =================================================

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const SizedBox
                .shrink();
          }

          final data =
              snapshot.data!
                      .data() ??
                  {};

          final String name =
              data['name']
                      ?.toString() ??
                  'Mentor';

          return SafeArea(
            top: false,

            child:
                Container(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                20,
                12,
                20,
                20,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: AppColors
                        .softMint
                        .withOpacity(
                      .08,
                    ),

                    blurRadius:
                        10,

                    offset:
                        const Offset(
                      0,
                      -2,
                    ),
                  ),
                ],
              ),

              child:
                  Row(
                children: [

                  // =========================================
                  // CHAT BUTTON
                  // =========================================

                  ChatMentorButton(
                    onPressed: () {
                      _openChat(
                        context:
                            context,
                        mentorName:
                            name,
                      );
                    },
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  // =========================================
                  // BOOKING BUTTON
                  // =========================================

                  Expanded(
                    child:
                        MentorBookingButton(
                      onPressed:
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    MentorBookingScreen(
                              mentorId:
                                  mentorId,
                              mentorName:
                                  name,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // =====================================================
      // APP BAR
      // =====================================================

      appBar:
          AppBar(
        title:
            const Text(
          'Thông tin Mentor',
        ),

        centerTitle:
            true,

        elevation:
            0,

        backgroundColor:
            Colors.transparent,

        foregroundColor:
            Colors.black,
      ),

      // =====================================================
      // MENTOR DATA
      // =====================================================

      body:
          StreamBuilder<
              DocumentSnapshot<
                  Map<String, dynamic>>>(
        stream:
            _mentorStream(),

        builder: (
          context,
          userSnapshot,
        ) {
          // =================================================
          // LOADING
          // =================================================

          if (userSnapshot
                  .connectionState ==
              ConnectionState
                  .waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // =================================================
          // ERROR
          // =================================================

          if (userSnapshot
              .hasError) {
            return MentorEmptyState(
              title:
                  'Không thể tải Mentor',

              message:
                  'Đã xảy ra lỗi khi tải thông tin Mentor.',

              icon:
                  Icons.error_outline,
            );
          }

          // =================================================
          // NOT FOUND
          // =================================================

          if (!userSnapshot
                  .hasData ||
              !userSnapshot
                  .data!
                  .exists) {
            return MentorEmptyState(
              title:
                  'Không tìm thấy Mentor',

              message:
                  'Mentor này có thể đã bị xóa hoặc không còn hoạt động.',

              icon:
                  Icons.person_off_outlined,
            );
          }

          // =================================================
          // MENTOR DATA
          // =================================================

          final data =
              userSnapshot
                      .data!
                      .data() ??
                  {};

          // =================================================
          // BASIC DATA
          // =================================================

          final String name =
              data['name']
                      ?.toString() ??
                  'Mentor';

          final String email =
              data['email']
                      ?.toString() ??
                  '';

          final String?
              avatarUrl =
              data['photoURL']
                  ?.toString();

          final String major =
              data['major']
                      ?.toString() ??
                  '';

          final String
              studentYear =
              data['studentYear']
                      ?.toString() ??
                  '';

          final int?
              birthYear =
              data['birthYear']
                      is num
                  ? (data['birthYear']
                          as num)
                      .toInt()
                  : null;

          final String about =
              data['bio']
                      ?.toString() ??
                  '';

          final List<String>
              skills =
              _parseStringList(
            data['skills'],
          );

          // =================================================
          // RATING SUMMARY
          // =================================================

          return FutureBuilder<
              Map<String, dynamic>>(
            future:
                AppointmentRatingService()
                    .getMentorRatingSummary(
              mentorId,
            ),

            builder: (
              context,
              ratingSnapshot,
            ) {
              double rating =
                  0.0;

              int totalRating =
                  0;

              // =============================================
              // GET RATING
              // =============================================

              if (ratingSnapshot
                  .hasData) {
                final result =
                    ratingSnapshot
                        .data!;

                final average =
                    result[
                        'averageRating'];

                final count =
                    result[
                        'reviewCount'];

                if (average
                    is num) {
                  rating =
                      average
                          .toDouble();
                }

                if (count
                    is num) {
                  totalRating =
                      count.toInt();
                }
              }

              // =============================================
              // GET REVIEWS
              // =============================================

              return StreamBuilder<
                  List<
                      AppointmentRatingModel>>(
                stream:
                    AppointmentRatingService()
                        .getMentorRatings(
                  mentorId,
                ),

                builder: (
                  context,
                  reviewSnapshot,
                ) {
                  final reviews =
                      reviewSnapshot
                              .data ??
                          [];

                  // =========================================
                  // GET SESSIONS
                  // =========================================

                  return StreamBuilder<
                      List<
                          SessionModel>>(
                    stream:
                        _mentorSessionsStream(),

                    builder: (
                      context,
                      sessionSnapshot,
                    ) {
                      final sessions =
                          sessionSnapshot
                                  .data ??
                              [];

                      return SingleChildScrollView(
                        physics:
                            const BouncingScrollPhysics(),

                        padding:
                            const EdgeInsets
                                .only(
                          bottom: 40,
                        ),

                        child:
                            Column(
                          children: [

                            // =================================
                            // HEADER
                            // =================================

                            MentorHeader(
                              name:
                                  name,

                              email:
                                  email,

                              avatarUrl:
                                  avatarUrl,

                              rating:
                                  rating,

                              totalRating:
                                  totalRating,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================
                            // BASIC INFO
                            // =================================

                            MentorBasicInfoCard(
                              major:
                                  major,

                              studentYear:
                                  studentYear,

                              birthYear:
                                  birthYear,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            // =================================
                            // ABOUT
                            // =================================

                            MentorAboutCard(
                              about:
                                  about,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            // =================================
                            // SKILLS
                            // =================================

                            MentorSkillsCard(
                              skills:
                                  skills,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================
                            // RATING SUMMARY
                            // =================================

                            Padding(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    20,
                              ),

                              child:
                                  MentorRating(
                                rating:
                                    rating,

                                totalRating:
                                    totalRating,
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================
                            // REVIEWS
                            // =================================

                            MentorReviewList(
                              reviews:
                                  reviews,

                              isLoading:
                                  reviewSnapshot
                                          .connectionState ==
                                      ConnectionState
                                          .waiting,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================
                            // UPCOMING SESSIONS
                            // =================================

                            MentorSessionList(
                              sessions:
                                  sessions,

                              isLoading:
                                  sessionSnapshot
                                          .connectionState ==
                                      ConnectionState
                                          .waiting,

                              errorMessage:
                                  sessionSnapshot
                                          .hasError
                                      ? 'Không thể tải Session.'
                                      : null,

                              onSessionTap:
                                  (
                                session,
                              ) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            MenteeSessionDetailScreen(
                                      session:
                                          session,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // =========================================================
  // PARSE STRING LIST
  // =========================================================

  List<String> _parseStringList(
    dynamic value,
  ) {
    if (value is List) {
      return value
          .map(
            (item) =>
                item
                    .toString()
                    .trim(),
          )
          .where(
            (item) =>
                item.isNotEmpty,
          )
          .toList();
    }

    return [];
  }
}