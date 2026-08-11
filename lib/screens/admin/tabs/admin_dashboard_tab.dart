
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../../../widgets/admin/admin_stats_grid.dart';
import '../../../widgets/admin/admin_session_stat_card.dart';
import '../../../widgets/admin/admin_pending_users_section.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =========================================================
      // NỀN XANH MINT
      // =========================================================

      backgroundColor: AppColors.lightMint,

      // =========================================================
      // BODY
      // Không còn AppBar màu đỏ
      // =========================================================

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .snapshots(),

        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (userSnapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi tải dữ liệu: ${userSnapshot.error}",
              ),
            );
          }

          final users =
              userSnapshot.data?.docs ?? [];

          // =====================================================
          // USER STATISTICS
          // =====================================================

          final int totalUsers = users.length;

          final int mentors = users.where((doc) {
            final data =
                doc.data() as Map<String, dynamic>;

            return data["role"]
                    ?.toString()
                    .toLowerCase() ==
                "mentor";
          }).length;

          final int mentees = users.where((doc) {
            final data =
                doc.data() as Map<String, dynamic>;

            return data["role"]
                    ?.toString()
                    .toLowerCase() ==
                "mentee";
          }).length;

          final int pendingApproval =
              users.where((doc) {
            final data =
                doc.data() as Map<String, dynamic>;

            return data["status"]
                    ?.toString()
                    .toLowerCase() ==
                "pending";
          }).length;

          // =====================================================
          // PENDING USERS
          // =====================================================

          final pendingUsers = users
              .where((doc) {
                final data =
                    doc.data()
                        as Map<String, dynamic>;

                return data["status"]
                        ?.toString()
                        .toLowerCase() ==
                    "pending";
              })
              .take(5)
              .map((doc) {
                final data =
                    doc.data()
                        as Map<String, dynamic>;

                return {
                  "uid": doc.id,
                  ...data,
                };
              })
              .toList();

          // =====================================================
          // SESSION STREAM
          // =====================================================

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sessions")
                .snapshots(),

            builder: (
              context,
              sessionSnapshot,
            ) {
              if (sessionSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (sessionSnapshot.hasError) {
                return Center(
                  child: Text(
                    "Lỗi tải Session: "
                    "${sessionSnapshot.error}",
                  ),
                );
              }

              final sessions =
                  sessionSnapshot.data?.docs ?? [];

              // =================================================
              // SESSION STATISTICS
              // =================================================

              final int totalSessions =
                  sessions.length;

              final int openSessions =
                  _countSessions(
                sessions,
                "open",
              );

              final int fullSessions =
                  _countSessions(
                sessions,
                "full",
              );

              final int completedSessions =
                  _countSessions(
                sessions,
                "completed",
              );

              final int cancelledSessions =
                  _countSessions(
                sessions,
                "cancelled",
              );

              // =================================================
              // DASHBOARD
              // =================================================

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // =========================================
                      // USER STATISTICS
                      // =========================================

                      const Text(
                        "User Statistics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      AdminStatsGrid(
                        totalUsers: totalUsers,
                        mentors: mentors,
                        mentees: mentees,
                        pendingApproval:
                            pendingApproval,
                      ),

                      const SizedBox(height: 30),

                      // =========================================
                      // SESSION STATISTICS
                      // =========================================

                      const Text(
                        "Session Statistics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,

                        children: [
                          AdminSessionStatCard(
                            title: "Total Sessions",
                            value:
                                totalSessions.toString(),
                            icon: Icons
                                .calendar_month_outlined,
                          ),

                          AdminSessionStatCard(
                            title: "Open",
                            value:
                                openSessions.toString(),
                            icon: Icons
                                .lock_open_outlined,
                          ),

                          AdminSessionStatCard(
                            title: "Full",
                            value:
                                fullSessions.toString(),
                            icon: Icons
                                .group_outlined,
                          ),

                          AdminSessionStatCard(
                            title: "Completed",
                            value:
                                completedSessions
                                    .toString(),
                            icon: Icons
                                .check_circle_outline,
                          ),

                          AdminSessionStatCard(
                            title: "Cancelled",
                            value:
                                cancelledSessions
                                    .toString(),
                            icon: Icons
                                .cancel_outlined,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // =========================================
                      // PENDING APPROVAL
                      // =========================================

                      AdminPendingUsersSection(
                        users: pendingUsers,

                        onApprove: (uid) {
                          _updateStatus(
                            uid,
                            "approved",
                          );
                        },

                        onReject: (uid) {
                          _updateStatus(
                            uid,
                            "rejected",
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // =========================================================
  // COUNT SESSION
  // =========================================================

  static int _countSessions(
    List<QueryDocumentSnapshot> sessions,
    String status,
  ) {
    return sessions.where((doc) {
      final data =
          doc.data() as Map<String, dynamic>;

      return data["status"]
              ?.toString()
              .toLowerCase() ==
          status;
    }).length;
  }

  // =========================================================
  // UPDATE USER STATUS
  // =========================================================

  static Future<void> _updateStatus(
    String uid,
    String status,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "status": status,
    });
  }
}
