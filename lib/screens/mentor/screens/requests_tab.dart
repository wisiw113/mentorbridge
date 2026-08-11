
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/services/appointment_service.dart';

import 'package:flutter_application_1/widgets/appointment/appointment_empty_state.dart';
import 'package:flutter_application_1/widgets/appointment/appointment_request_card.dart';
import 'package:flutter_application_1/widgets/appointment/appointment_status_filter.dart';
import 'package:flutter_application_1/widgets/appointment/reject_reason_popup.dart';

import 'package:flutter_application_1/screens/common/appointment_detail_screen.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({
    super.key,
  });

  @override
  State<RequestsTab> createState() =>
      _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  final AppointmentService _service =
      AppointmentService();

  String selectedStatus = "all";

  // =========================================================
  // OPEN APPOINTMENT DETAIL
  // =========================================================

  void _openAppointmentDetail(
    AppointmentModel appointment,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailScreen(
          appointment: appointment,
        ),
      ),
    );
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
          gradient: AppColors.backgroundGradient,
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
    // REQUEST LIST
    // =======================================================

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: StreamBuilder<List<AppointmentModel>>(
        stream: _service.getMentorAppointments(
          user.uid,
        ),
        builder: (
          context,
          snapshot,
        ) {
          // ===================================================
          // LOADING
          // ===================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mintGreen,
              ),
            );
          }

          // ===================================================
          // ERROR
          // ===================================================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Text(
                  "Không thể tải yêu cầu.\n${snapshot.error}",
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
          // APPOINTMENTS
          // ===================================================

          final appointments =
              snapshot.data ?? [];

          // ===================================================
          // FILTER
          // ===================================================

          final filteredAppointments =
              _filterAppointments(
            appointments,
          );

          return Column(
            children: [
              const SizedBox(
                height: 16,
              ),

              // =================================================
              // STATUS FILTER
              // =================================================

              AppointmentStatusFilter(
                selectedStatus:
                    selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus =
                        value;
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // =================================================
              // APPOINTMENT LIST
              // =================================================

              Expanded(
                child:
                    filteredAppointments.isEmpty
                        ? const AppointmentEmptyState()
                        : ListView.separated(
                            padding:
                                const EdgeInsets.only(
                              bottom: 100,
                            ),
                            itemCount:
                                filteredAppointments
                                    .length,
                            separatorBuilder:
                                (_, __) =>
                                    const SizedBox(
                              height: 12,
                            ),
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              final appointment =
                                  filteredAppointments[
                                      index];

                              final status =
                                  appointment
                                      .status
                                      .toLowerCase();

                              // =================================
                              // CHECK CAN COMPLETE
                              // =================================

                              final canComplete =
                                  status ==
                                          "accepted" &&
                                      _canComplete(
                                        appointment,
                                      );

                              // =================================
                              // APPOINTMENT CARD
                              // =================================

                              return InkWell(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),

                                // =================================
                                // OPEN DETAIL
                                // =================================

                                onTap: () {
                                  _openAppointmentDetail(
                                    appointment,
                                  );
                                },

                                child:
                                    AppointmentRequestCard(
                                  appointment:
                                      appointment,

                                  // =================================
                                  // ACCEPT
                                  // =================================

                                  onAccept:
                                      status ==
                                              "pending"
                                          ? () =>
                                              _updateStatus(
                                                appointment,
                                                "accepted",
                                              )
                                          : null,

                                  // =================================
                                  // REJECT
                                  // =================================

                                  onReject:
                                      status ==
                                              "pending"
                                          ? () =>
                                              _rejectAppointment(
                                                appointment
                                                    .id,
                                              )
                                          : null,

                                  // =================================
                                  // CAN COMPLETE
                                  // =================================

                                  canComplete:
                                      canComplete,

                                  // =================================
                                  // COMPLETE
                                  // =================================

                                  onComplete:
                                      canComplete
                                          ? () =>
                                              _updateStatus(
                                                appointment,
                                                "completed",
                                              )
                                          : null,
                                ),
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

  // =========================================================
  // REJECT APPOINTMENT
  // =========================================================

  Future<void> _rejectAppointment(
    String appointmentId,
  ) async {
    final reason =
        await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          AppColors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return const RejectReasonPopup();
      },
    );

    // =======================================================
    // USER CANCEL REJECT
    // =======================================================

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    // =======================================================
    // REJECT
    // =======================================================

    try {
      await _service.rejectAppointment(
        appointmentId: appointmentId,
        reason: reason.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Đã từ chối yêu cầu.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Có lỗi xảy ra: $e",
          ),
        ),
      );
    }
  }

  // =========================================================
  // FILTER
  // =========================================================

  List<AppointmentModel>
      _filterAppointments(
    List<AppointmentModel>
        appointments,
  ) {
    // =======================================================
    // SHOW ALL
    // =======================================================

    if (selectedStatus == "all") {
      return appointments;
    }

    // =======================================================
    // FILTER BY STATUS
    // =======================================================

    return appointments
        .where(
          (appointment) =>
              appointment.status
                  .toLowerCase() ==
              selectedStatus
                  .toLowerCase(),
        )
        .toList();
  }

  // =========================================================
  // CAN COMPLETE
  // =========================================================

  bool _canComplete(
    AppointmentModel appointment,
  ) {
    return DateTime.now().isAfter(
      appointment.endAt,
    );
  }

  // =========================================================
  // UPDATE STATUS
  // =========================================================
  //
  // accepted  -> acceptAppointment()
  // completed -> completeAppointment()
  //
  // rejected được xử lý riêng trong
  // _rejectAppointment().
  // =========================================================

  Future<void> _updateStatus(
    AppointmentModel appointment,
    String status,
  ) async {
    try {
      // =======================================================
      // ACCEPT
      // =======================================================

      switch (status) {
        case "accepted":
          await _service.acceptAppointment(
            appointment.id,
          );
          break;

        // =====================================================
        // COMPLETE
        // =====================================================

        case "completed":
          await _service.completeAppointment(
            appointment,
          );
          break;

        // =====================================================
        // OTHER STATUS
        // =====================================================

        default:
          return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _statusMessage(status),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Có lỗi xảy ra: $e",
          ),
        ),
      );
    }
  }

  // =========================================================
  // STATUS MESSAGE
  // =========================================================

  String _statusMessage(
    String status,
  ) {
    switch (status) {
      case "accepted":
        return "Đã chấp nhận yêu cầu.";

      case "rejected":
        return "Đã từ chối yêu cầu.";

      case "completed":
        return "Appointment đã hoàn thành.";

      case "cancelled":
        return "Appointment đã được hủy.";

      default:
        return "Đã cập nhật trạng thái.";
    }
  }
}

