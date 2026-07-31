import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/models/appointment_model.dart';
import '/models/session_model.dart';
import '/models/schedule_item.dart';
import '/services/appointment_service.dart';
import '/services/session_service.dart';

import '/widgets/common/greeting_card.dart';
import '/widgets/mentee/mentee_home/upcoming_learning_card.dart';
import '/widgets/mentee/mentee_home/upcoming_session_card.dart';
import '/widgets/common/weekly_schedule_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.lightMint,
        body: Center(
          child: Text(
            'Chưa đăng nhập',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.darkGray,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightMint,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final userData = userSnapshot.data?.data();

            // Lấy tên từ Firestore
            final name =
                userData?['name']?.toString().trim().isNotEmpty == true
                    ? userData!['name'].toString()
                    : 'Bạn';

            return StreamBuilder<List<AppointmentModel>>(
              stream: AppointmentService()
                  .getMenteeAppointments(user.uid),
              builder: (context, appointmentSnapshot) {
                if (appointmentSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (appointmentSnapshot.hasError) {
                  return const _ErrorView(
                    message: 'Không thể tải lịch hẹn.',
                  );
                }

                final appointments =
                    appointmentSnapshot.data ?? [];

                return StreamBuilder<List<SessionModel>>(
                  stream: SessionService()
                      .getMenteeSessions(user.uid),
                  builder: (context, sessionSnapshot) {
                    if (sessionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (sessionSnapshot.hasError) {
                      return const _ErrorView(
                        message: 'Không thể tải Session.',
                      );
                    }

                    final sessions =
                        sessionSnapshot.data ?? [];

                    return _HomeContent(
                      name: name,
                      appointments: appointments,
                      sessions: sessions,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// HOME CONTENT
// ============================================================

class _HomeContent extends StatelessWidget {
  final String name;
  final List<AppointmentModel> appointments;
  final List<SessionModel> sessions;

  const _HomeContent({
    required this.name,
    required this.appointments,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    // ========================================================
    // APPOINTMENT ĐÃ ACCEPT
    // ========================================================

    final acceptedAppointments = appointments
        .where(
          (appointment) =>
              appointment.status == 'accepted',
        )
        .toList();

    // ========================================================
    // SESSION ĐÃ JOIN
    // ========================================================

    final joinedSessions = sessions
        .where(
          (session) =>
              session.status != 'cancelled',
        )
        .toList();

    // ========================================================
    // SORT
    // ========================================================

    acceptedAppointments.sort(
      (a, b) => a.startAt.compareTo(b.startAt),
    );

    joinedSessions.sort(
      (a, b) => a.startAt.compareTo(b.startAt),
    );

    // ========================================================
    // TẠO SCHEDULE
    // Appointment + Session
    // ========================================================

    final List<ScheduleItem> scheduleItems = [
      ...acceptedAppointments.map(
        ScheduleItem.fromAppointment,
      ),
      ...joinedSessions.map(
        ScheduleItem.fromSession,
      ),
    ];

    // Sort toàn bộ lịch
    scheduleItems.sort(
      (a, b) => a.startAt.compareTo(b.startAt),
    );

    // ========================================================
    // UPCOMING APPOINTMENTS
    // ========================================================

    final upcomingAppointments = acceptedAppointments
        .where(
          (appointment) =>
              appointment.startAt.isAfter(DateTime.now()),
        )
        .toList();

    // ========================================================
    // UPCOMING SESSIONS
    // ========================================================

    final upcomingSessions = joinedSessions
        .where(
          (session) =>
              session.startAt.isAfter(DateTime.now()),
        )
        .toList();

    // ========================================================
    // UPCOMING LEARNING
    //
    // Lấy lịch gần nhất giữa Appointment và Session
    // ========================================================

    final List<ScheduleItem> learningItems = [
      ...upcomingAppointments.map(
        ScheduleItem.fromAppointment,
      ),
      ...upcomingSessions.map(
        ScheduleItem.fromSession,
      ),
    ];

    learningItems.sort(
      (a, b) => a.startAt.compareTo(b.startAt),
    );

    final ScheduleItem? upcomingLearning =
        learningItems.isNotEmpty
            ? learningItems.first
            : null;

    // ========================================================
    // UI
    // ========================================================

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ======================================================
        // GREETING
        // ======================================================

        GreetingCard(
          userName: name,
        ),

        const SizedBox(height: 20),

        // ======================================================
        // WEEKLY SCHEDULE
        // ======================================================

        const _SectionTitle(
          title: 'Thời khóa biểu',
          icon: Icons.calendar_month_outlined,
        ),

        const SizedBox(height: 10),

        WeeklyScheduleCard(
          schedules: scheduleItems,
          onDayTap: (_) {},
          onViewAll: () {},
        ),

        const SizedBox(height: 20),

        // ======================================================
        // UPCOMING LEARNING
        // ======================================================

        const _SectionTitle(
          title: 'Upcoming Learning',
          icon: Icons.school_outlined,
        ),

        const SizedBox(height: 10),

        if (upcomingLearning == null)
          const _EmptyCard(
            icon: Icons.event_available_outlined,
            message: 'Bạn chưa có lịch học sắp tới.',
          )
        else
          UpcomingLearningCard(
            item: upcomingLearning,
          ),

        const SizedBox(height: 20),

        // ======================================================
        // UPCOMING SESSION
        // ======================================================

        const _SectionTitle(
          title: 'Session sắp tham gia',
          icon: Icons.groups_outlined,
        ),

        const SizedBox(height: 10),

        if (upcomingSessions.isEmpty)
          const _EmptyCard(
            icon: Icons.groups_outlined,
            message: 'Bạn chưa có Session sắp tham gia.',
          )
        else
          UpcomingSessionCard(
            session: upcomingSessions.first,
            onPressed: () {},
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: AppColors.deepGreen,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// EMPTY CARD
// ============================================================

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyCard({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 38,
            color: AppColors.gray,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.gray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ERROR VIEW
// ============================================================

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.darkGray,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}