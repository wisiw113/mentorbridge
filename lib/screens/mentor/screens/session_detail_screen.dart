import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';

import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_info_card.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_document_card.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_management_buttons.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_participants_header.dart';
import 'package:flutter_application_1/widgets/session/session_detail/session_participants_list.dart';

class SessionDetailScreen
    extends StatefulWidget {
  final SessionModel session;

  const SessionDetailScreen({
    super.key,
    required this.session,
  });

  @override
  State<SessionDetailScreen>
      createState() =>
          _SessionDetailScreenState();
}

class _SessionDetailScreenState
    extends State<SessionDetailScreen> {
  final SessionService
      _sessionService =
      SessionService();

  late SessionModel session;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    session =
        widget.session;

    _refreshSession();
  }

  // =========================================================
  // REFRESH SESSION STATUS
  // =========================================================

  Future<void>
      _refreshSession() async {
    try {
      final updated =
          await _sessionService
              .getSession(
        session.id,
      );

      if (!mounted ||
          updated == null) {
        return;
      }

      setState(() {
        session = updated;
      });
    } catch (_) {
      // Không cần hiển thị lỗi
      // vì màn hình vẫn có dữ liệu cũ
    }
  }

  // =========================================================
  // CANCEL SESSION
  // =========================================================

  Future<void>
      _cancelSession() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder:
          (context) {
        return AlertDialog(
          title: const Text(
            "Cancel Session",
          ),
          content:
              const Text(
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
              child:
                  const Text(
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
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text(
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
      await _sessionService
          .cancelSession(
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
            e
                .toString()
                .replaceFirst(
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
    return session.status ==
        "open";
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFFECFDF5,
      ),
      appBar: AppBar(
        title:
            const Text(
          "Session Detail",
        ),
        backgroundColor:
            const Color(
          0xFF047857,
        ),
        foregroundColor:
            Colors.white,
        elevation: 0,
      ),
      body:
          RefreshIndicator(
        onRefresh:
            _refreshSession,
        child:
            SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          child:
              Column(
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

              if (session.fileUrl !=
                      null &&
                  session.fileUrl!
                      .isNotEmpty)
                SessionDocumentCard(
                  fileName:
                      session.fileName,
                  onTap: () {
                    // Xử lý mở / tải file
                    // bằng logic hiện tại
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
              // PARTICIPANTS
              // =================================================

              SessionParticipantsList(
                sessionId:
                    session.id,
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