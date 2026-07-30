import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';

import 'package:flutter_application_1/widgets/session/session_info_card.dart';

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

  // ================= CHECK JOINED =================

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

  // ================= OPEN DOCUMENT =================

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

  // ================= JOIN =================

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

    if (session.bookedSlots >=
        session.maxSlots) {
      _showMessage(
        "Session đã đầy.",
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

    setState(() {
      _isLoading = true;
    });

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

      final data = userDoc.data();

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

  // ================= LEAVE =================

  Future<void> _leaveSession() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(
        "Vui lòng đăng nhập.",
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

  // ================= GET PARTICIPANT =================

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

  // ================= MESSAGE =================

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

  // ================= CHECK FULL =================

  bool get _isFull {
    return session.bookedSlots >=
        session.maxSlots;
  }

  // ================= BUILD =================

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
            // ================= SESSION INFO =================

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

            // ================= DOCUMENT =================

            if (session.fileUrl != null &&
                session.fileUrl!.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Card(
                  elevation: 1,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.green
                            .withOpacity(
                          0.1,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: const Icon(
                        Icons
                            .description_outlined,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      session.fileName ??
                          "Session Document",
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    subtitle:
                        const Text(
                      "Nhấn để mở tài liệu",
                    ),
                    trailing:
                        const Icon(
                      Icons
                          .download_outlined,
                    ),
                    onTap:
                        _openDocument,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // ================= ACTION =================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                child:
                    _buildActionButton(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= ACTION BUTTON =================

  Widget _buildActionButton() {
    if (_isLoading) {
      return const SizedBox(
        height: 52,
        child: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (_isJoined) {
      return ElevatedButton.icon(
        onPressed:
            _leaveSession,
        icon: const Icon(
          Icons.exit_to_app,
        ),
        label: const Text(
          "Leave Session",
        ),
        style:
            ElevatedButton.styleFrom(
          minimumSize:
              const Size(
            double.infinity,
            52,
          ),
          backgroundColor:
              Colors.red,
          foregroundColor:
              Colors.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
        ),
      );
    }

    if (_isFull) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.group,
        ),
        label: const Text(
          "Session Full",
        ),
        style:
            ElevatedButton.styleFrom(
          minimumSize:
              const Size(
            double.infinity,
            52,
          ),
        ),
      );
    }

    if (session.status
            .toLowerCase() ==
        "completed") {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.check_circle,
        ),
        label: const Text(
          "Session Completed",
        ),
        style:
            ElevatedButton.styleFrom(
          minimumSize:
              const Size(
            double.infinity,
            52,
          ),
        ),
      );
    }

    if (session.status
            .toLowerCase() ==
        "cancelled") {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.cancel,
        ),
        label: const Text(
          "Session Cancelled",
        ),
        style:
            ElevatedButton.styleFrom(
          minimumSize:
              const Size(
            double.infinity,
            52,
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed:
          _joinSession,
      icon: const Icon(
        Icons.groups,
      ),
      label: const Text(
        "Join Session",
      ),
      style:
          ElevatedButton.styleFrom(
        minimumSize:
            const Size(
          double.infinity,
          52,
        ),
        backgroundColor:
            Colors.green,
        foregroundColor:
            Colors.white,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),
      ),
    );
  }
}