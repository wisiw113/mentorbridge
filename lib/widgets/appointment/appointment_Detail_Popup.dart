import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/appointment_model.dart';

import '../appointment/appointment_info_row.dart';
import '../appointment/appointment_status_badge.dart';

class AppointmentDetailPopup extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailPopup({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildHandle(),

            const SizedBox(height: 20),

            _buildHeader(),

            const SizedBox(height: 20),

            AppointmentInfoRow(
              icon: Icons.person_outline,
              title: "Mentor",
              value: appointment.mentorName,
            ),

            const SizedBox(height: 14),

            AppointmentInfoRow(
              icon: Icons.calendar_month_outlined,
              title: "Date",
              value: appointment.date,
            ),

            const SizedBox(height: 14),

            AppointmentInfoRow(
              icon: Icons.schedule_outlined,
              title: "Time",
              value: appointment.time,
            ),

            if (appointment.note.isNotEmpty) ...[
              const SizedBox(height: 14),

              AppointmentInfoRow(
                icon: Icons.notes_outlined,
                title: "Note",
                value: appointment.note,
              ),
            ],

            if (appointment.rejectReason != null &&
                appointment.rejectReason!.isNotEmpty)
              _buildRejectReason(),

            const SizedBox(height: 24),

            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Appointment Details",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.deepGreen,
          ),
        ),

        AppointmentStatusBadge(
          status: appointment.status,
        ),
      ],
    );
  }

  Widget _buildRejectReason() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.error.withOpacity(.25),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.error,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reject Reason",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  appointment.rejectReason!,
                  style: const TextStyle(
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepGreen,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Close",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}