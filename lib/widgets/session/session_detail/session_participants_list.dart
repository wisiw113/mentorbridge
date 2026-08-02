import 'package:flutter/material.dart';

import '../../../models/session_participant_model.dart';
import '../../../services/session_service.dart';
import '../mentor_session_activity/participant_card.dart';

class SessionParticipantsList extends StatelessWidget {
  final String sessionId;
  final bool canKick;

  const SessionParticipantsList({
    super.key,
    required this.sessionId,
    this.canKick = false,
  });

  @override
  Widget build(BuildContext context) {
    final SessionService service = SessionService();

    return StreamBuilder<List<SessionParticipantModel>>(
      stream: service.getParticipants(sessionId),
      builder: (context, snapshot) {
        // =====================================================
        // LOADING
        // =====================================================

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // =====================================================
        // ERROR
        // =====================================================

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Không thể tải danh sách participants.\n\n"
                  "${snapshot.error}",
                ),
              ),
            ),
          );
        }

        // =====================================================
        // PARTICIPANTS
        // =====================================================

        final List<SessionParticipantModel> participants =
            snapshot.data ?? [];

        // =====================================================
        // EMPTY
        // =====================================================

        if (participants.isEmpty) {
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 50,
                      color: Color(0xFF10B981),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Chưa có người tham gia",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Danh sách mentee sẽ xuất hiện ở đây.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // =====================================================
        // LIST
        // =====================================================

        return Column(
          children: participants.map((participant) {
            return ParticipantCard(
              name: participant.menteeName,
              email: participant.menteeId,
              avatarUrl: null,
              joinedAt: participant.joinedAt,

              onTap: () {},

              // =================================================
              // KICK
              // =================================================

              onKick: canKick
                  ? () {
                      _showKickDialog(
                        context,
                        service,
                        participant,
                      );
                    }
                  : null,
            );
          }).toList(),
        );
      },
    );
  }

  // ===========================================================
  // KICK CONFIRMATION
  // ===========================================================

  Future<void> _showKickDialog(
    BuildContext context,
    SessionService service,
    SessionParticipantModel participant,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Kick mentee",
          ),

          content: Text(
            "Bạn có chắc muốn kick "
            "${participant.menteeName} khỏi Session này không?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
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
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Kick",
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    // =========================================================
    // CALL SERVICE
    // =========================================================

    try {
      await service.kickParticipant(
        sessionId: sessionId,
        participantId: participant.id,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Đã kick ${participant.menteeName} khỏi Session.",
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              "Exception: ",
              "",
            ),
          ),
        ),
      );
    }
  }
}