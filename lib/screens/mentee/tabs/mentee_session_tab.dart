
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';
import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_card.dart';
import 'package:flutter_application_1/widgets/mentee/mentee_session/filter_session_bar.dart';
import 'package:flutter_application_1/screens/mentee/screens/mentee_session_detail_screen.dart';

class MenteeSessionTab extends StatefulWidget {
  const MenteeSessionTab({super.key});

  @override
  State<MenteeSessionTab> createState() =>
      _MenteeSessionTabState();
}

class _MenteeSessionTabState
    extends State<MenteeSessionTab> {
  final SessionService _sessionService =
      SessionService();

  // =========================
  // SẮP XẾP MẶC ĐỊNH
  // =========================

  String selectedSort = 'nearest';

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
                "Không thể tải buổi học.\n"
                "${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final sessions =
              List<SessionModel>.from(
            snapshot.data ?? [],
          );

          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                "Bạn chưa tham gia buổi học nào.",
                style: TextStyle(
                  color: AppColors.gray,
                ),
              ),
            );
          }

          // =========================
          // SẮP XẾP THEO NGÀY
          // =========================

          sessions.sort((a, b) {
            final dateA = _parseDate(a.date);
            final dateB = _parseDate(b.date);

            if (selectedSort == 'nearest') {
              return dateA.compareTo(dateB);
            }

            return dateB.compareTo(dateA);
          });

          return Column(
            children: [
              // =========================
              // THANH SẮP XẾP
              // =========================

              FilterSessionBar(
                selectedSort: selectedSort,
                onChanged: (value) {
                  setState(() {
                    selectedSort = value;
                  });
                },
              ),

              // =========================
              // DANH SÁCH SESSION
              // =========================

              Expanded(
                child: ListView.separated(
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

                      // Đã tham gia rồi nên không hiện nút tham gia
                      onJoin: null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =========================
  // CHUYỂN NGÀY TỪ STRING
  // =========================

  DateTime _parseDate(String date) {
    final parts = date.split("-");

    if (parts.length != 3) {
      return DateTime(9999);
    }

    return DateTime(
      int.tryParse(parts[0]) ?? 9999,
      int.tryParse(parts[1]) ?? 1,
      int.tryParse(parts[2]) ?? 1,
    );
  }
}

