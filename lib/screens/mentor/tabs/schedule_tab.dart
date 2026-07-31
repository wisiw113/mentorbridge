import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  void _showAppointmentDetail(
    BuildContext context,
    AppointmentModel appointment,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Appointment Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mentee: ${appointment.menteeName}",
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    appointment.date,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    appointment.time,
                  ),
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
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    List<DateTime> bookedDates,
  ) async {
    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 430,
            child: MonthCalendarWidget(
              initialMonth:
                  selectedDate ?? DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Chưa đăng nhập"),
      );
    }

    return StreamBuilder<List<AppointmentModel>>(
      stream: _appointmentService.getMentorRequests(
        user.uid,
      ),
      builder: (context, appointmentSnapshot) {
        if (appointmentSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (appointmentSnapshot.hasError) {
          return Center(
            child: Text(
              "Lỗi tải Appointment:\n"
              "${appointmentSnapshot.error}",
              textAlign: TextAlign.center,
            ),
          );
        }

        return StreamBuilder<List<SessionModel>>(
          stream: _sessionService.getMentorSessions(
            user.uid,
          ),
          builder: (context, sessionSnapshot) {
            if (sessionSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (sessionSnapshot.hasError) {
              return Center(
                child: Text(
                  "Lỗi tải Session:\n"
                  "${sessionSnapshot.error}",
                  textAlign: TextAlign.center,
                ),
              );
            }

            final appointments =
                appointmentSnapshot.data ?? [];

            final sessions =
                sessionSnapshot.data ?? [];

            final bookedDates = [
              ...appointments
                  .where(
                    (appointment) =>
                        appointment.status == "accepted" ||
                        appointment.status == "completed",
                  )
                  .map(
                    (appointment) =>
                        parseDate(appointment.date),
                  ),
              ...sessions.map(
                (session) =>
                    parseDate(session.date),
              ),
            ];

            final selectedAppointments =
                selectedDate == null
                    ? <AppointmentModel>[]
                    : appointments.where(
                        (appointment) {
                          return isSameDate(
                            parseDate(
                              appointment.date,
                            ),
                            selectedDate!,
                          );
                        },
                      ).toList();

            final selectedSessions =
                selectedDate == null
                    ? <SessionModel>[]
                    : sessions.where(
                        (session) {
                          return isSameDate(
                            parseDate(
                              session.date,
                            ),
                            selectedDate!,
                          );
                        },
                      ).toList();

            return Column(
              children: [
                ScheduleDateSelector(
                  selectedDate: selectedDate,
                  dateText: selectedDate == null
                      ? "Chọn ngày"
                      : formatDate(selectedDate!),
                  onTap: () {
                    _selectDate(
                      context,
                      bookedDates,
                    );
                  },
                ),
                Expanded(
                  child: selectedDate == null
                      ? const Center(
                          child: Text(
                            "Chọn ngày để xem lịch",
                          ),
                        )
                      : ListView(
                          padding:
                              const EdgeInsets.only(
                            bottom: 30,
                          ),
                          children: [
                            const SectionTitle(
                              title: "Appointments",
                            ),
                            if (selectedAppointments.isEmpty)
                              const ScheduleEmptyCard(
                                message:
                                    "Không có Appointment trong ngày này.",
                              ),
                            ...selectedAppointments.map(
                              (appointment) {
                                return AppointmentScheduleCard(
                                  appointment: appointment,
                                  onTap: () {
                                    _showAppointmentDetail(
                                      context,
                                      appointment,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            const SectionTitle(
                              title: "Group Sessions",
                            ),
                            if (selectedSessions.isEmpty)
                              const ScheduleEmptyCard(
                                message:
                                    "Không có Session trong ngày này.",
                              ),
                            ...selectedSessions.map(
                              (session) {
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
                                  status: session.status,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SessionDetailScreen(
                                          session: session,
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
    );
  }
}