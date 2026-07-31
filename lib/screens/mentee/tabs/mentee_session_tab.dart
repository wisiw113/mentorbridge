import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';
import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_card.dart';
import 'package:flutter_application_1/screens/mentee/screens/mentee_session_detail_screen.dart';

class MenteeSessionTab extends StatelessWidget {
  MenteeSessionTab({super.key});

  final SessionService _sessionService =
      SessionService();

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Chưa đăng nhập"),
      );
    }

    return Container(
      color: AppColors.lightMint,
      child: StreamBuilder<List<SessionModel>>(
        stream: _sessionService
            .getMenteeSessions(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mintGreen,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Không thể tải Session.\n"
                "${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final sessions =
              snapshot.data ?? [];

          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                "Bạn chưa tham gia Session nào.",
                style: TextStyle(
                  color: AppColors.gray,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 24,
            ),
            itemCount: sessions.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final session =
                  sessions[index];

              return SessionCard(
                title: session.title,
                description:
                    session.description,
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

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MenteeSessionDetailScreen(
                        session: session,
                      ),
                    ),
                  );
                },

                // Đã tham gia rồi nên không hiện nút Join
                onJoin: null,
              );
            },
          );
        },
      ),
    );
  }
}