
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../../../models/session_model.dart';

import '../../../widgets/admin/admin_session_management/admin_session_header.dart';
import '../../../widgets/admin/admin_session_management/admin_session_filter.dart';
import '../../../widgets/admin/admin_session_management/admin_session_card.dart';
import '../../../widgets/admin/admin_session_management/admin_session_empty_state.dart';
import '../../../widgets/admin/admin_session_management/admin_session_detail_dialog.dart';

class AdminSessionManagementScreen extends StatefulWidget {
  const AdminSessionManagementScreen({super.key});

  @override
  State<AdminSessionManagementScreen> createState() =>
      _AdminSessionManagementScreenState();
}

class _AdminSessionManagementScreenState
    extends State<AdminSessionManagementScreen> {
  final CollectionReference sessionsRef =
      FirebaseFirestore.instance.collection('sessions');

  String _selectedStatus = 'all';

  // =====================================================
  // FILTER
  // =====================================================

  List<SessionModel> _filterSessions(
    List<SessionModel> sessions,
  ) {
    if (_selectedStatus == 'all') {
      return sessions;
    }

    return sessions.where((session) {
      return session.status == _selectedStatus;
    }).toList();
  }

  // =====================================================
  // SHOW DETAIL
  // =====================================================

  void _showSessionDetails(SessionModel session) {
    showDialog(
      context: context,
      builder: (_) {
        return AdminSessionDetailDialog(
          sessionId: session.id,
          title: session.title,
          description: session.description,
          mentorName: session.mentorName,
          date: session.date,
          startTime: session.startTime,
          endTime: session.endTime,
          bookedSlots: session.bookedSlots,
          maxSlots: session.maxSlots,
          status: session.status,
          fileName: session.fileName,
          fileUrl: session.fileUrl,
        );
      },
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMint.withOpacity(0.12),

      body: StreamBuilder<QuerySnapshot>(
        stream: sessionsRef.snapshots(),

        builder: (context, snapshot) {
          // =================================================
          // ERROR
          // =================================================

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          // =================================================
          // LOADING
          // =================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mintGreen,
              ),
            );
          }

          // =================================================
          // NO DATA
          // =================================================

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const AdminSessionEmptyState(
              message: 'No sessions found',
            );
          }

          // =================================================
          // CONVERT TO MODEL
          // =================================================

          final sessions = snapshot.data!.docs.map((doc) {
            final data =
                doc.data() as Map<String, dynamic>;

            return SessionModel.fromMap(
              doc.id,
              data,
            );
          }).toList();

          final filteredSessions =
              _filterSessions(sessions);

          // =================================================
          // CONTENT
          // =================================================

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // =================================================
              // HEADER
              // =================================================

              AdminSessionHeader(
                totalSessions: sessions.length,
              ),

              const SizedBox(height: 16),

              // =================================================
              // FILTER
              // =================================================

              AdminSessionFilter(
                selectedStatus: _selectedStatus,
                onStatusChanged: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),

              const SizedBox(height: 16),

              // =================================================
              // FILTER EMPTY
              // =================================================

              if (filteredSessions.isEmpty)
                const AdminSessionEmptyState(
                  message: 'No matching sessions',
                ),

              // =================================================
              // SESSION LIST
              // =================================================

              ...filteredSessions.map((session) {
                return AdminSessionCard(
                  title: session.title,
                  mentorName: session.mentorName,
                  date: session.date,
                  startTime: session.startTime,
                  endTime: session.endTime,
                  bookedSlots: session.bookedSlots,
                  maxSlots: session.maxSlots,
                  status: session.status,
                  hasFile: session.fileName != null &&
                      session.fileName!.isNotEmpty,
                  onViewDetails: () {
                    _showSessionDetails(session);
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

