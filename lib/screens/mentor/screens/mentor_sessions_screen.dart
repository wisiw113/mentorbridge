  import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';

import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_card.dart';

import 'create_session_screen.dart';
import 'session_detail_screen.dart';

class MentorSessionsScreen extends StatefulWidget {
  const MentorSessionsScreen({
    super.key,
  });

  @override
  State<MentorSessionsScreen> createState() =>
      _MentorSessionsScreenState();
}

class _MentorSessionsScreenState
    extends State<MentorSessionsScreen> {
  final SessionService _sessionService =
      SessionService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // =========================
    // CHƯA ĐĂNG NHẬP
    // =========================

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Sessions"),
        ),
        body: const Center(
          child: Text(
            "Chưa đăng nhập",
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Sessions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // CREATE SESSION
      // =========================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateSessionScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          "Create Session",
        ),
      ),

      // =========================
      // GET MENTOR SESSIONS
      // =========================

      body: StreamBuilder<List<SessionModel>>(
        stream: _sessionService.getMentorSessions(
          user.uid,
        ),

        builder: (
          context,
          snapshot,
        ) {
          // =========================
          // LOADING
          // =========================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =========================
          // ERROR
          // =========================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [

                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    const Text(
                      "Không thể tải Session",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      snapshot.error.toString(),
                      textAlign:
                          TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                  ],
                ),
              ),
            );
          }

          // =========================
          // DATA
          // =========================

          final sessions =
              snapshot.data ?? [];

          // =========================
          // EMPTY
          // =========================

          if (sessions.isEmpty) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.all(24),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.green
                                .withOpacity(
                                    0.08),
                        shape:
                            BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.groups_outlined,
                        size: 60,
                        color:
                            Color(0xFF10B981),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    const Text(
                      "Chưa có Session nào",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      "Tạo Session đầu tiên của bạn để bắt đầu kết nối với Mentee.",
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const CreateSessionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                      label: const Text(
                        "Tạo Session",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // =========================
          // SESSION LIST
          // =========================

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },

            child: ListView.builder(
              padding:
                  const EdgeInsets.only(
                top: 12,
                bottom: 100,
              ),

              itemCount:
                  sessions.length,

              itemBuilder:
                  (context, index) {
                final session =
                    sessions[index];

                return SessionCard(
                  // =========================
                  // SESSION INFO
                  // =========================

                  title:
                      session.title,

                  description:
                      session.description,

                  date:
                      session.date,

                  startTime:
                      session.startTime,

                  endTime:
                      session.endTime,

                  // =========================
                  // SLOT
                  // =========================

                  bookedSlots:
                      session.bookedSlots,

                  maxSlots:
                      session.maxSlots,

                  // =========================
                  // STATUS
                  // =========================

                  status:
                      session.status,

                  // =========================
                  // TAP CARD
                  // =========================

                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SessionDetailScreen(
                          session:
                              session,
                        ),
                      ),
                    );
                  },

                  // =========================
                  // JOIN
                  // =========================
                  //
                  // Mentor không join
                  // Session của chính mình.
                  //
                  // Nút Join trong SessionCard
                  // hiện tại sẽ được ẩn bằng
                  // onJoin = null.
                  //

                  onJoin: null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}