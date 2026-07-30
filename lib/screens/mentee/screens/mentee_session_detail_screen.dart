
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';

import 'package:flutter_application_1/widgets/session/session_info_card.dart';
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

  bool _isLoading = false;
  bool _isJoined = false;

  SessionModel get session => widget.session;

  @override
  void initState() {
    super.initState();
    _checkJoined();
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

    // Không cho Leave nếu session đã kết thúc
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
  // HELPERS
  // =========================================================

  bool get _isFull {
    return session.bookedSlots >=
        session.maxSlots;
  }

  bool get _isSessionFinished {
    final status =
        session.status.toLowerCase();

    return status == "completed" ||
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
              title: session.title,
              description:
                  session.description,
              mentorName:
                  session.mentorName,
              date: session.date,
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
            // PARTICIPANT ACTIONS
            // =================================================

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
