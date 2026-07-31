
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
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // =================================================
              // HANDLE
              // =================================================

              _buildHandle(),

              const SizedBox(height: 20),

              // =================================================
              // HEADER
              // =================================================

              _buildHeader(),

              const SizedBox(height: 24),

              // =================================================
              // MENTOR CARD
              // =================================================

              _buildMentorCard(),

              const SizedBox(height: 20),

              // =================================================
              // APPOINTMENT INFORMATION
              // =================================================

              _buildSectionTitle(
                icon: Icons.event_note_outlined,
                title: "Appointment Information",
              ),

              const SizedBox(height: 12),

              _buildInformationCard(),

              // =================================================
              // NOTE
              // =================================================

              if (appointment.note.trim().isNotEmpty) ...[
                const SizedBox(height: 20),

                _buildSectionTitle(
                  icon: Icons.notes_outlined,
                  title: "Note",
                ),

                const SizedBox(height: 12),

                _buildNoteCard(),
              ],

              // =================================================
              // REJECT REASON
              // =================================================

              if (appointment.rejectReason != null &&
                  appointment.rejectReason!
                      .trim()
                      .isNotEmpty) ...[
                const SizedBox(height: 20),

                _buildRejectReason(),
              ],

              const SizedBox(height: 28),

              // =================================================
              // CLOSE BUTTON
              // =================================================

              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HANDLE
  // =========================================================

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 42,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius:
              BorderRadius.circular(10),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Appointment Details",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppColors.deepGreen,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Thông tin chi tiết lịch hẹn",
                style: TextStyle(
                  fontSize: 13,
                  color:
                      Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        AppointmentStatusBadge(
          status: appointment.status,
        ),
      ],
    );
  }

  // =========================================================
  // MENTOR CARD
  // =========================================================

  Widget _buildMentorCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.deepGreen
                .withOpacity(.10),
            AppColors.deepGreen
                .withOpacity(.04),
          ],
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.deepGreen
              .withOpacity(.12),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color:
                  AppColors.deepGreen,
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: const Icon(
              Icons.person_outline,
              color:
                  AppColors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          // Mentor information
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Mentor",
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  appointment.mentorName,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppColors.deepGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              AppColors.deepGreen,
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.bold,
            color:
                AppColors.darkGray,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // INFORMATION CARD
  // =========================================================

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        children: [
          AppointmentInfoRow(
            icon:
                Icons.calendar_month_outlined,
            title: "Date",
            value:
                appointment.date,
          ),

          const SizedBox(height: 16),

          AppointmentInfoRow(
            icon:
                Icons.schedule_outlined,
            title: "Time",
            value:
                appointment.time,
          ),

          if (appointment.topic
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 16),

            AppointmentInfoRow(
              icon:
                  Icons.topic_outlined,
              title: "Topic",
              value:
                  appointment.topic,
            ),
          ],

          const SizedBox(height: 16),

          AppointmentInfoRow(
            icon:
                Icons.info_outline,
            title: "Status",
            value:
                _formatStatus(
              appointment.status,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // NOTE CARD
  // =========================================================

  Widget _buildNoteCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  AppColors.deepGreen
                      .withOpacity(.10),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notes_outlined,
              size: 20,
              color:
                  AppColors.deepGreen,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              appointment.note,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color:
                    AppColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // REJECT REASON
  // =========================================================

  Widget _buildRejectReason() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            AppColors.error
                .withOpacity(.07),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              AppColors.error
                  .withOpacity(.25),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  AppColors.error
                      .withOpacity(.12),
              shape:
                  BoxShape.circle,
            ),
            child: const Icon(
              Icons.priority_high_rounded,
              size: 20,
              color:
                  AppColors.error,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reject Reason",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppColors.error,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  appointment
                      .rejectReason!,
                  style:
                      const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color:
                        AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CLOSE BUTTON
  // =========================================================

  Widget _buildCloseButton(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.close_rounded,
          size: 20,
        ),
        label: const Text(
          "Close",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 15,
          ),
        ),
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.deepGreen,
          foregroundColor:
              AppColors.white,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(
            vertical: 15,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FORMAT STATUS
  // =========================================================

  String _formatStatus(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case "pending":
        return "Pending";

      case "accepted":
        return "Accepted";

      case "rejected":
        return "Rejected";

      case "completed":
      case "complete":
        return "Completed";

      case "cancelled":
      case "canceled":
        return "Cancelled";

      default:
        return status;
    }
  }
}

