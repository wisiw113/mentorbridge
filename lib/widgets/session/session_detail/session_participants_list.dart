import 'package:flutter/material.dart';

import '../../../models/session_participant_model.dart';
import '../../../services/session_service.dart';
import '../mentor_session_activity/participant_card.dart';

class SessionParticipantsList extends StatelessWidget {
  final String sessionId;

  const SessionParticipantsList({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    final service = SessionService();

    return StreamBuilder<
        List<SessionParticipantModel>>(
      stream: service.getParticipants(sessionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

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

        final participants =
            snapshot.data ?? [];

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

        return Column(
          children: participants
              .map(
                (participant) =>
                    ParticipantCard(
                  name: participant.menteeName,
                  email: participant.menteeId,
                  avatarUrl: null,
                  joinedAt:
                      participant.joinedAt,
                  onTap: () {},
                ),
              )
              .toList(),
        );
      },
    );
  }
}