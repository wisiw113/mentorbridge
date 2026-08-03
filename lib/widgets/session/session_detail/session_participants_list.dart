
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // =========================================================
  // GET USER PROFILE
  // =========================================================

  Future<Map<String, dynamic>> _getUserProfile(
    String userId,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!snapshot.exists) {
        return {
          'name': 'Mentee',
          'email': '',
          'photoURL': '',
        };
      }

      final data = snapshot.data() ?? {};

      // =======================================================
      // NAME
      // =======================================================

      String name =
          data['name']?.toString().trim() ?? '';

      if (name.isEmpty) {
        name =
            data['displayName']?.toString().trim() ?? '';
      }

      if (name.isEmpty) {
        name = 'Mentee';
      }

      // =======================================================
      // EMAIL
      // =======================================================

      final email =
          data['email']?.toString().trim() ?? '';

      // =======================================================
      // PHOTO URL
      // =======================================================

      final photoURL =
          data['photoURL']?.toString().trim() ?? '';

      return {
        'name': name,
        'email': email,
        'photoURL': photoURL,
      };
    } catch (_) {
      return {
        'name': 'Mentee',
        'email': '',
        'photoURL': '',
      };
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final SessionService service =
        SessionService();

    return StreamBuilder<
        List<SessionParticipantModel>>(
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

        final List<SessionParticipantModel>
            participants =
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
                        fontWeight:
                            FontWeight.w600,
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
          children: participants.map(
            (participant) {
              return FutureBuilder<
                  Map<String, dynamic>>(
                future: _getUserProfile(
                  participant.menteeId,
                ),
                builder: (
                  context,
                  userSnapshot,
                ) {
                  // =================================================
                  // PROFILE LOADING
                  // =================================================

                  if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildLoadingCard();
                  }

                  // =================================================
                  // PROFILE DATA
                  // =================================================

                  final userData =
                      userSnapshot.data ?? {};

                  final name =
                      userData['name']
                              ?.toString()
                              .trim()
                              .isNotEmpty ==
                          true
                          ? userData['name']
                              .toString()
                              .trim()
                          : participant.menteeName;

                  final email =
                      userData['email']
                              ?.toString()
                              .trim() ??
                          '';

                  final photoURL =
                      userData['photoURL']
                              ?.toString()
                              .trim() ??
                          '';

                  // =================================================
                  // PARTICIPANT CARD
                  // =================================================

                  return ParticipantCard(
                    name: name,

                    // ===============================================
                    // EMAIL THẬT
                    // KHÔNG DÙNG menteeId
                    // ===============================================

                    email: email,

                    // ===============================================
                    // AVATAR THẬT
                    // ===============================================

                    avatarUrl:
                        photoURL.isNotEmpty
                            ? photoURL
                            : null,

                    joinedAt:
                        participant.joinedAt,

                    onTap: () {
                      // Có thể mở MenteeProfileScreen ở đây
                    },

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
                },
              );
            },
          ).toList(),
        );
      },
    );
  }

  // =========================================================
  // LOADING CARD
  // =========================================================

  Widget _buildLoadingCard() {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
                  Color(0xFFE5E7EB),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 14,
                    width: 140,
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(
                        color:
                            Color(0xFFE5E7EB),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  SizedBox(
                    height: 12,
                    width: 190,
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(
                        color:
                            Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    final bool? confirm =
        await showDialog<bool>(
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
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor:
                    Colors.white,
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

      ScaffoldMessenger.of(context)
          .showSnackBar(
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

      ScaffoldMessenger.of(context)
          .showSnackBar(
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

