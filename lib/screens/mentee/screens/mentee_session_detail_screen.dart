import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/models/session_rating_model.dart';

import 'package:flutter_application_1/services/session_service.dart';
import 'package:flutter_application_1/services/session_rating_service.dart';

import 'package:flutter_application_1/widgets/common/rating_popup.dart';

import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_info_card.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_document_card.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_participant_actions.dart';

class MenteeSessionDetailScreen extends StatefulWidget {
  final SessionModel session;

  const MenteeSessionDetailScreen({
    super.key,
    required this.session,
  });

  @override
  State<MenteeSessionDetailScreen> createState() =>
      _MenteeSessionDetailScreenState();
}

class _MenteeSessionDetailScreenState
    extends State<MenteeSessionDetailScreen> {
  final SessionService _sessionService =
      SessionService();

  final SessionRatingService _ratingService =
      SessionRatingService();

  bool _isLoading = false;
  bool _isJoined = false;
  bool _isRated = false;
  bool _isRatingLoading = false;

  SessionModel get session => widget.session;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  // =========================================================
  // INITIALIZE
  // =========================================================

  Future<void> _initialize() async {
    await _checkJoined();
    await _checkRated();
  }

  // =========================================================
  // CHECK JOINED
  // =========================================================

  Future<void> _checkJoined() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    try {
      final joined =
          await _sessionService.hasJoined(
        sessionId: session.id,
        menteeId: user.uid,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isJoined = joined;
      });
    } catch (e) {
      debugPrint(
        "Check joined error: $e",
      );
    }
  }

  // =========================================================
  // CHECK RATED
  // =========================================================

  Future<void> _checkRated() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    try {
      final rated =
          await _ratingService.hasRatedSession(
        sessionId: session.id,
        menteeId: user.uid,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isRated = rated;
      });
    } catch (e) {
      debugPrint(
        "Check rated error: $e",
      );
    }
  }

  // =========================================================
  // OPEN DOCUMENT
  // =========================================================

  Future<void> _openDocument() async {
    if (session.fileUrl == null ||
        session.fileUrl!.isEmpty) {
      _showMessage(
        "Session này chưa có tài liệu.",
      );
      return;
    }

    final shouldOpen =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tài liệu Session",
          ),
          content: Text(
            "Bạn có muốn mở tài liệu "
            "\"${session.fileName ?? "Session Document"}\" không?",
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
                "Hủy",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                "Mở tài liệu",
              ),
            ),
          ],
        );
      },
    );

    if (shouldOpen != true) {
      return;
    }

    try {
      final uri =
          Uri.parse(session.fileUrl!);

      final launched =
          await launchUrl(
        uri,
        mode:
            LaunchMode.externalApplication,
      );

      if (!launched) {
        _showMessage(
          "Không thể mở tài liệu.",
        );
      }
    } catch (e) {
      _showMessage(
        "Không thể mở tài liệu: $e",
      );
    }
  }

  // =========================================================
  // JOIN SESSION
  // =========================================================

  Future<void> _joinSession() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(
        "Vui lòng đăng nhập.",
      );
      return;
    }

    if (_isJoined) {
      _showMessage(
        "Bạn đã tham gia session này.",
      );
      return;
    }

    if (session.status.toLowerCase() !=
        "open") {
      _showMessage(
        "Session hiện không thể tham gia.",
      );
      return;
    }

    if (_isFull) {
      _showMessage(
        "Session đã đầy.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

      final data =
          userDoc.data();

      final String menteeName =
          (data?["name"] ?? "")
                  .toString()
                  .isNotEmpty
              ? data!["name"].toString()
              : user.displayName ??
                  "Mentee";

      await _sessionService.joinSession(
        session: session,
        menteeId: user.uid,
        menteeName: menteeName,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isJoined = true;
      });

      _showMessage(
        "Tham gia session thành công!",
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        e.toString().replaceFirst(
          "Exception: ",
          "",
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // LEAVE SESSION
  // =========================================================

  Future<void> _leaveSession() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(
        "Vui lòng đăng nhập.",
      );
      return;
    }

    if (_isSessionFinished) {
      _showMessage(
        "Không thể rời Session đã kết thúc.",
      );
      return;
    }

    final participantId =
        await _getParticipantId();

    if (participantId == null) {
      _showMessage(
        "Không tìm thấy thông tin tham gia.",
      );
      return;
    }

    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Rời Session?",
          ),
          content: const Text(
            "Bạn có chắc muốn rời khỏi session này không?",
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
                "Hủy",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                "Rời Session",
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
      _isLoading = true;
    });

    try {
      await _sessionService.leaveSession(
        sessionId: session.id,
        participantId: participantId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isJoined = false;
      });

      _showMessage(
        "Đã rời khỏi session.",
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        e.toString().replaceFirst(
          "Exception: ",
          "",
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // GET PARTICIPANT ID
  // =========================================================

  Future<String?> _getParticipantId() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    try {
      final result =
          await FirebaseFirestore.instance
              .collection(
                "session_participants",
              )
              .where(
                "sessionId",
                isEqualTo: session.id,
              )
              .where(
                "menteeId",
                isEqualTo: user.uid,
              )
              .where(
                "status",
                isEqualTo: "joined",
              )
              .limit(1)
              .get();

      if (result.docs.isEmpty) {
        return null;
      }

      return result.docs.first.id;
    } catch (e) {
      debugPrint(
        "Get participant ID error: $e",
      );

      return null;
    }
  }

  // =========================================================
  // SHOW RATING POPUP
  // =========================================================

  Future<void> _showRatingDialog() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(
        "Vui lòng đăng nhập.",
      );
      return;
    }

    // =======================================================
    // CHECK SESSION COMPLETED
    // =======================================================

    if (!_isSessionCompleted) {
      _showMessage(
        "Bạn chỉ có thể đánh giá sau khi Session hoàn thành.",
      );
      return;
    }

    // =======================================================
    // CHECK JOINED
    // =======================================================

    if (!_isJoined) {
      _showMessage(
        "Bạn phải tham gia Session mới có thể đánh giá.",
      );
      return;
    }

    // =======================================================
    // CHECK ALREADY RATED
    // =======================================================

    if (_isRated) {
      _showMessage(
        "Bạn đã đánh giá Session này rồi.",
      );
      return;
    }

    // =======================================================
    // SHOW POPUP
    // =======================================================

    final result =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) {
        return const RatingPopup();
      },
    );

    if (result == null) {
      return;
    }

    final ratingValue =
        result["rating"] as int?;

    final comment =
        result["comment"] as String? ?? "";

    if (ratingValue == null) {
      _showMessage(
        "Vui lòng chọn số sao.",
      );
      return;
    }

    // =======================================================
    // LOADING
    // =======================================================

    setState(() {
      _isRatingLoading = true;
    });

    try {
      // =====================================================
      // GET MENTEE NAME
      // =====================================================

      final userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

      final userData =
          userDoc.data();

      final menteeName =
          (userData?["name"] ?? "")
                  .toString()
                  .trim()
                  .isNotEmpty
              ? userData!["name"]
                  .toString()
                  .trim()
              : user.displayName ??
                  "Mentee";

      // =====================================================
      // CREATE RATING MODEL
      // =====================================================

      final rating =
          SessionRatingModel(
        id: "",
        sessionId: session.id,
        mentorId: session.mentorId,
        menteeId: user.uid,
        mentorName: session.mentorName,
        menteeName: menteeName,
        rating:
            ratingValue.toDouble(),
        comment: comment.trim(),
        createdAt: DateTime.now(),
      );

      // =====================================================
      // SAVE RATING
      // =====================================================

      await _ratingService
          .createSessionRating(
        rating,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isRated = true;
      });

      _showMessage(
        "Đánh giá Session thành công!",
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        e.toString().replaceFirst(
          "Exception: ",
          "",
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRatingLoading = false;
        });
      }
    }
  }

  // =========================================================
  // HELPERS
  // =========================================================

  bool get _isFull {
    return session.bookedSlots >=
        session.maxSlots;
  }

  bool get _isSessionCompleted {
    final status =
        session.status.toLowerCase();

    return status == "completed" ||
        status == "complete";
  }

  bool get _isSessionFinished {
    final status =
        session.status.toLowerCase();

    return status == "completed" ||
        status == "complete" ||
        status == "cancelled";
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  // =========================================================
  // RATING SECTION
  // =========================================================

  Widget _buildRatingSection() {
    if (!_isSessionCompleted) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        0,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: Colors.amber,
                size: 26,
              ),
              SizedBox(width: 8),
              Text(
                "Đánh giá Session",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            _isRated
                ? "Bạn đã gửi đánh giá cho Session này."
                : "Hãy chia sẻ trải nghiệm của bạn về Session.",
            style: TextStyle(
              color:
                  Colors.grey.shade600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: _isRated
                ? Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 12,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .green
                          .withOpacity(.08),
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Icon(
                          Icons
                              .check_circle,
                          color:
                              Colors.green,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Đã đánh giá",
                          style: TextStyle(
                            color:
                                Colors.green,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed:
                        _isRatingLoading
                            ? null
                            : _showRatingDialog,
                    icon:
                        _isRatingLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons
                                    .star_rounded,
                              ),
                    label: Text(
                      _isRatingLoading
                          ? "Đang gửi..."
                          : "Đánh giá Session",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.amber.shade700,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 13,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
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
      appBar: AppBar(
        title: const Text(
          "Session Details",
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
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
                onTap:
                    _openDocument,
              ),

            const SizedBox(
              height: 10,
            ),

            // =================================================
            // RATING
            // =================================================

            _buildRatingSection(),

            const SizedBox(
              height: 10,
            ),

            SessionParticipantActions(
              isLoading:
                  _isLoading,
              isJoined:
                  _isJoined,
              isFull:
                  _isFull,
              status:
                  session.status,
              onJoin:
                  _joinSession,
              onLeave:
                  _leaveSession,
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

