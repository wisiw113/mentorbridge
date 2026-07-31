
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';
import 'package:flutter_application_1/services/session_rating_service.dart';

import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_info_card.dart';

import 'package:flutter_application_1/widgets/session/session_detail/session_document_card.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_management_buttons.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_participants_header.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_participants_list.dart';

// Rating widgets
import 'package:flutter_application_1/widgets/session/session_detail/session_rating_list.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_rating_summary_card.dart';

class SessionDetailScreen extends StatefulWidget {
  final SessionModel session;

  const SessionDetailScreen({
    super.key,
    required this.session,
  });

  @override
  State<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState
    extends State<SessionDetailScreen> {
  final SessionService _sessionService =
      SessionService();

  final SessionRatingService _ratingService =
      SessionRatingService();

  late SessionModel session;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    session = widget.session;

    _refreshSession();
  }

  // =========================================================
  // REFRESH SESSION
  // =========================================================

  Future<void> _refreshSession() async {
    try {
      final updated =
          await _sessionService.getSession(
        session.id,
      );

      if (!mounted || updated == null) {
        return;
      }

      setState(() {
        session = updated;
      });
    } catch (_) {
      // Giữ dữ liệu cũ nếu refresh lỗi
    }
  }

  // =========================================================
  // CANCEL SESSION
  // =========================================================

  Future<void> _cancelSession() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Cancel Session",
          ),
          content: const Text(
            "Bạn có chắc chắn muốn hủy Session này không?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                "No",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                "Yes, Cancel",
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await _sessionService.cancelSession(
        session.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Session đã được hủy.",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  "Exception: ",
                  "",
                ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // =========================================================
  // CAN CANCEL
  // =========================================================

  bool get canCancel {
    return session.status.toLowerCase() == "open";
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFECFDF5),

      appBar: AppBar(
        title: const Text(
          "Session Detail",
        ),
        backgroundColor:
            const Color(0xFF047857),
        foregroundColor:
            Colors.white,
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: _refreshSession,

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // =================================================
              // SESSION INFO
              // =================================================

              SessionInfoCard(
                title:
                    session.title,

                description:
                    session.description,

                mentorName:
                    session.mentorName,

                date:
                    session.date,

                startTime:
                    session.startTime,

                endTime:
                    session.endTime,

                bookedSlots:
                    session.bookedSlots,

                maxSlots:
                    session.maxSlots,

                status:
                    session.status,
              ),

              // =================================================
              // DOCUMENT
              // =================================================

              if (session.fileUrl != null &&
                  session.fileUrl!.isNotEmpty)

                SessionDocumentCard(
                  fileName:
                      session.fileName,

                  onTap: () {
                    // Xử lý mở tài liệu
                  },
                ),

              const SizedBox(
                height: 10,
              ),

              // =================================================
              // PARTICIPANTS HEADER
              // =================================================

              SessionParticipantsHeader(
                bookedSlots:
                    session.bookedSlots,

                maxSlots:
                    session.maxSlots,
              ),

              const SizedBox(
                height: 10,
              ),

              // =================================================
              // PARTICIPANTS LIST
              // =================================================

              SessionParticipantsList(
                sessionId:
                    session.id,
              ),

              const SizedBox(
                height: 20,
              ),

              // =================================================
              // SESSION RATINGS
              // =================================================

              StreamBuilder(
                stream:
                    _ratingService
                        .getSessionRatings(
                  session.id,
                ),

                builder: (
                  context,
                  snapshot,
                ) {

                  // =================================================
                  // LOADING
                  // =================================================

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {

                    return const Padding(
                      padding:
                          EdgeInsets.all(30),

                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    );
                  }

                  // =================================================
                  // ERROR
                  // =================================================

                  if (snapshot.hasError) {

                    return Padding(
                      padding:
                          const EdgeInsets.all(20),

                      child: Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets.all(16),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.red
                                  .withOpacity(0.08),

                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        child: Row(
                          children: [

                            const Icon(
                              Icons.error_outline,
                              color:
                                  Colors.red,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: Text(
                                "Không thể tải đánh giá Session.",
                                style:
                                    TextStyle(
                                  color:
                                      Colors.red
                                          .shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // =================================================
                  // GET RATINGS
                  // =================================================

                  final ratings =
                      snapshot.data ?? [];

                  // =================================================
                  // CALCULATE AVERAGE
                  // =================================================

                  double averageRating = 0.0;

                  if (ratings.isNotEmpty) {

                    double totalRating = 0.0;

                    for (final rating
                        in ratings) {

                      totalRating +=
                          rating.rating;
                    }

                    averageRating =
                        totalRating /
                            ratings.length;
                  }

                  // =================================================
                  // RATING UI
                  // =================================================

                  return Column(
                    children: [

                      // =================================================
                      // RATING SUMMARY
                      // =================================================

                      SessionRatingSummaryCard(
                        averageRating:
                            averageRating,

                        reviewCount:
                            ratings.length,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // =================================================
                      // RATING LIST
                      // =================================================

                      SessionRatingList(
                        ratings:
                            ratings,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(
                height: 30,
              ),

              // =================================================
              // MANAGEMENT BUTTON
              // =================================================

              SessionManagementButtons(
                visible:
                    canCancel,

                loading:
                    loading,

                onCancel:
                    _cancelSession,
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

