import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/services/appointment_service.dart';

import 'package:flutter_application_1/widgets/appointment/mentor_booking_screen/booking_mentor_card.dart';
import 'package:flutter_application_1/widgets/appointment/mentor_booking_screen/booking_note_field.dart';
import 'package:flutter_application_1/widgets/appointment/mentor_booking_screen/booking_submit_button.dart';
import 'package:flutter_application_1/widgets/appointment/mentor_booking_screen/booking_time_selector.dart';
import 'package:flutter_application_1/widgets/appointment/mentor_booking_screen/booking_topic_selector.dart';

import 'package:flutter_application_1/widgets/session/session_create/session_date_picker.dart';

class MentorBookingScreen extends StatefulWidget {
  final String mentorId;
  final String mentorName;

  const MentorBookingScreen({
    super.key,
    required this.mentorId,
    required this.mentorName,
  });

  @override
  State<MentorBookingScreen> createState() =>
      _MentorBookingScreenState();
}

class _MentorBookingScreenState
    extends State<MentorBookingScreen> {
  final AppointmentService _service =
      AppointmentService();

  final TextEditingController noteController =
      TextEditingController();

  DateTime? selectedDate;

  String? selectedSlot;

  String? selectedTopic;

  bool isLoading = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  // =====================================================
  // BOOK APPOINTMENT
  // =====================================================

  Future<void> bookAppointment() async {
    if (isLoading) return;

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Vui lòng chọn ngày.",
          ),
        ),
      );
      return;
    }

    if (selectedSlot == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Vui lòng chọn khung giờ.",
          ),
        ),
      );
      return;
    }

    if (selectedTopic == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Vui lòng chọn chủ đề tư vấn.",
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final times =
          selectedSlot!.split(" - ");

      final start =
          times.first.split(":");

      final end =
          times.last.split(":");

      final startAt = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        int.parse(start[0]),
        int.parse(start[1]),
      );

      final endAt = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        int.parse(end[0]),
        int.parse(end[1]),
      );

      final appointment =
          AppointmentModel(
        id: "",

        mentorId: widget.mentorId,

        menteeId: user.uid,

        mentorName:
            widget.mentorName,

        menteeName:
            user.email ?? "",

        date: DateFormat(
          "yyyy-MM-dd",
        ).format(selectedDate!),

        startTime: times.first,

        endTime: times.last,

        time: selectedSlot!,

        topic: selectedTopic!,

        note: noteController.text
            .trim(),

        status: "pending",

        rated: false,

        startAt: startAt,

        endAt: endAt,

        createdAt:
            DateTime.now(),
      );

      await _service.bookAppointment(
        appointment,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Đặt lịch thành công.",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
    // =====================================================
  // UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đặt lịch với ${widget.mentorName}",
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              BookingMentorCard(
                mentorName:
                    widget.mentorName,
              ),

              const SizedBox(
                height: 24,
              ),

              SessionDatePicker(
                selectedDate:
                    selectedDate,
                onDateSelected:
                    (date) {
                  setState(() {
                    selectedDate =
                        date;
                  });
                },
              ),

              const SizedBox(
                height: 24,
              ),

              BookingTimeSelector(
                selectedTime:
                    selectedSlot,
                onChanged:
                    (value) {
                  setState(() {
                    selectedSlot =
                        value;
                  });
                },
              ),

              const SizedBox(
                height: 24,
              ),

              BookingTopicSelector(
                selectedTopic:
                    selectedTopic,
                onChanged:
                    (value) {
                  setState(() {
                    selectedTopic =
                        value;
                  });
                },
              ),

              const SizedBox(
                height: 24,
              ),

              BookingNoteField(
                controller:
                    noteController,
              ),

              const SizedBox(
                height: 32,
              ),

              BookingSubmitButton(
                isLoading:
                    isLoading,
                onPressed:
                    bookAppointment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
