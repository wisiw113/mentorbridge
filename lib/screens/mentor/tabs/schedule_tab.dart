
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/models/session_model.dart';

import 'package:flutter_application_1/services/appointment_service.dart';
import 'package:flutter_application_1/services/session_service.dart';

import 'package:flutter_application_1/screens/mentor/screens/session_detail_screen.dart';

import 'package:flutter_application_1/widgets/calendar/month_calendar_widget.dart';
import 'package:flutter_application_1/widgets/calendar/schedule_date_selector.dart';
import 'package:flutter_application_1/widgets/calendar/appointment_schedule_card.dart';
import 'package:flutter_application_1/widgets/calendar/schedule_empty_card.dart';
import 'package:flutter_application_1/widgets/calendar/section_title.dart';
import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_card.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  final AppointmentService _appointmentService =
      AppointmentService();

  final SessionService _sessionService =
      SessionService();

  DateTime? selectedDate = DateTime.now();

  // =========================================================
  // PARSE DATE
  // =========================================================

  DateTime parseDate(String date) {
    final parts = date.split("-");

    if (parts.length != 3) {
      return DateTime.now();
    }

    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  // =========================================================
  // CHECK SAME DATE
  // =========================================================

  bool isSameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // =========================================================
  // SHOW APPOINTMENT DETAIL
  // =========================================================

  void _showAppointmentDetail(
    BuildContext context,
    AppointmentModel appointment,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Chi tiết cuộc hẹn",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Người học: ${appointment.menteeName}",
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: AppColors.mintGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(appointment.date),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 18,
                    color: AppColors.mintGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(appointment.time),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notes,
                    size: 18,
                    color: AppColors.mintGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.note.isEmpty
                          ? "Không có ghi chú"
                          : appointment.note,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Đóng",
                style: TextStyle(
                  color: AppColors.deepGreen,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // SELECT DATE
  // =========================================================

  Future<void> _selectDate(
    BuildContext context,
    List<DateTime> bookedDates,
  ) async {
    final pickedDate =
        await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 430,
            child: MonthCalendarWidget(
              initialMonth:
                  selectedDate ??
                      DateTime.now(),
              bookedDates: bookedDates,
              onDateSelected: (date) {
                Navigator.pop(
                  dialogContext,
                  date,
                );
              },
            ),
          ),
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    // =======================================================
    // CHƯA ĐĂNG NHẬP
    // =======================================================

    if (user == null) {
      return Container(
        decoration: const BoxDecoration(
          gradient:
              AppColors.backgroundGradient,
        ),
        child: const Center(
          child: Text(
            "Chưa đăng nhập",
            style: TextStyle(
              color: AppColors.deepGreen,
            ),
          ),
        ),
      );
    }

    // =======================================================
    // BACKGROUND GRADIENT
    // =======================================================

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: StreamBuilder<
          List<AppointmentModel>>(
        // =====================================================
        // APPOINTMENTS
        // =====================================================

        stream: _appointmentService
            .getMentorAppointments(
          user.uid,
        ),

        builder: (
          context,
          appointmentSnapshot,
        ) {
          // ===================================================
          // LOADING APPOINTMENT
          // ===================================================

          if (appointmentSnapshot
                  .connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color: AppColors.mintGreen,
              ),
            );
          }

          // ===================================================
          // ERROR APPOINTMENT
          // ===================================================

          if (appointmentSnapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Text(
                  "Lỗi tải dữ liệu cuộc hẹn:\n"
                  "${appointmentSnapshot.error}",
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.error,
                  ),
                ),
              ),
            );
          }

          // ===================================================
          // SESSION STREAM
          // ===================================================

          return StreamBuilder<
              List<SessionModel>>(
            stream: _sessionService
                .getMentorSessions(
              user.uid,
            ),

            builder: (
              context,
              sessionSnapshot,
            ) {
              // =============================================
              // LOADING SESSION
              // =============================================

              if (sessionSnapshot
                      .connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        AppColors.mintGreen,
                  ),
                );
              }

              // =============================================
              // ERROR SESSION
              // =============================================

              if (sessionSnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      24,
                    ),
                    child: Text(
                      "Lỗi tải dữ liệu buổi học nhóm:\n"
                      "${sessionSnapshot.error}",
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color:
                            AppColors.error,
                      ),
                    ),
                  ),
                );
              }

              // =============================================
              // DATA
              // =============================================

              final appointments =
                  appointmentSnapshot.data ??
                      [];

              final sessions =
                  sessionSnapshot.data ?? [];

              // =============================================
              // BOOKED DATES
              // =============================================

              final bookedDates = [
                ...appointments
                    .where(
                      (appointment) =>
                          appointment.status ==
                              "accepted" ||
                          appointment.status ==
                              "completed",
                    )
                    .map(
                      (appointment) =>
                          parseDate(
                        appointment.date,
                      ),
                    ),

                ...sessions.map(
                  (session) =>
                      parseDate(
                    session.date,
                  ),
                ),
              ];

              // =============================================
              // SELECTED APPOINTMENTS
              // =============================================

              final selectedAppointments =
                  selectedDate == null
                      ? <AppointmentModel>[]
                      : appointments
                          .where(
                            (appointment) {
                              return isSameDate(
                                parseDate(
                                  appointment.date,
                                ),
                                selectedDate!,
                              );
                            },
                          )
                          .toList();

              // =============================================
              // SELECTED SESSIONS
              // =============================================

              final selectedSessions =
                  selectedDate == null
                      ? <SessionModel>[]
                      : sessions
                          .where(
                            (session) {
                              return isSameDate(
                                parseDate(
                                  session.date,
                                ),
                                selectedDate!,
                              );
                            },
                          )
                          .toList();

              // =============================================
              // MAIN CONTENT
              // =============================================

              return Column(
                children: [
                  // =========================================
                  // DATE SELECTOR
                  // =========================================

                  ScheduleDateSelector(
                    selectedDate:
                        selectedDate,
                    dateText:
                        selectedDate == null
                            ? "Chọn ngày"
                            : formatDate(
                                selectedDate!,
                              ),
                    onTap: () {
                      _selectDate(
                        context,
                        bookedDates,
                      );
                    },
                  ),

                  // =========================================
                  // CONTENT
                  // =========================================

                  Expanded(
                    child:
                        selectedDate == null
                            ? const Center(
                                child: Text(
                                  "Chọn ngày để xem lịch",
                                  style:
                                      TextStyle(
                                    color: AppColors
                                        .darkGray,
                                  ),
                                ),
                              )
                            : ListView(
                                padding:
                                    const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 30,
                                ),
                                children: [
                                  // =================================
                                  // APPOINTMENTS
                                  // =================================

                                  const SectionTitle(
                                    title:
                                        "Cuộc hẹn",
                                  ),

                                  if (selectedAppointments
                                      .isEmpty)
                                    const ScheduleEmptyCard(
                                      message:
                                          "Không có cuộc hẹn nào trong ngày này.",
                                    ),

                                  ...selectedAppointments
                                      .map(
                                    (
                                      appointment,
                                    ) {
                                      return AppointmentScheduleCard(
                                        appointment:
                                            appointment,
                                        onTap: () {
                                          _showAppointmentDetail(
                                            context,
                                            appointment,
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // =================================
                                  // SESSIONS
                                  // =================================

                                  const SectionTitle(
                                    title:
                                        "Buổi học nhóm",
                                  ),

                                  if (selectedSessions
                                      .isEmpty)
                                    const ScheduleEmptyCard(
                                      message:
                                          "Không có buổi học nhóm nào trong ngày này.",
                                    ),

                                  ...selectedSessions
                                      .map(
                                    (session) {
                                      return SessionCard(
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
                                        bookedSlots:
                                            session.bookedSlots,
                                        maxSlots:
                                            session.maxSlots,
                                        status:
                                            session.status,

                                        // ===========================
                                        // OPEN SESSION DETAIL
                                        // ===========================

                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) =>
                                                      SessionDetailScreen(
                                                session:
                                                    session,
                                              ),
                                            ),
                                          );
                                        },

                                        onJoin: null,
                                      );
                                    },
                                  ),
                                ],
                              ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
