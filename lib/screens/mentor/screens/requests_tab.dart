import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/services/appointment_service.dart';

import 'package:flutter_application_1/widgets/appointment/appointment_empty_state.dart';
import 'package:flutter_application_1/widgets/appointment/appointment_request_card.dart';
import 'package:flutter_application_1/widgets/appointment/appointment_status_filter.dart';
import 'package:flutter_application_1/widgets/appointment/reject_reason_popup.dart';
import 'package:flutter_application_1/widgets/appointment/appointment_detail_popup.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({
    super.key,
  });

  @override
  State<RequestsTab> createState() =>
      _RequestsTabState();
}

class _RequestsTabState
    extends State<RequestsTab> {
  final AppointmentService _service =
      AppointmentService();

  String selectedStatus = "all";

  // =========================================================
  // SHOW APPOINTMENT DETAIL
  // =========================================================

  void _showAppointmentDetail(
    BuildContext context,
    AppointmentModel appointment,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AppointmentDetailPopup(
          appointment: appointment,
        );
      },
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Container(
        color: AppColors.lightMint,
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

    return ColoredBox(
      color: AppColors.lightMint,
      child: StreamBuilder<
          List<AppointmentModel>>(
        stream: _service.getMentorRequests(
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
              const SizedBox(height: 16),

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

              const SizedBox(height: 20),

              // =================================================
              // LIST
              // =================================================

              Expanded(
                child:
                    filteredAppointments
                            .isEmpty
                        ? const AppointmentEmptyState()
                        : ListView.separated(
                            padding:
                                const EdgeInsets.only(
                              bottom: 24,
                            ),
                            itemCount:
                                filteredAppointments
                                    .length,
                            separatorBuilder:
                                (
                              _,
                              __,
                            ) =>
                                    const SizedBox(
                              height: 12,
                            ),
                            itemBuilder:
                                (
                              context,
                              index,
                            ) {
                              final appointment =
                                  filteredAppointments[
                                      index];

                              final status =
                                  appointment.status
                                      .toLowerCase();

                              // =================================
                              // CAN COMPLETE
                              // =================================

                              final canComplete =
                                  status ==
                                          "accepted" &&
                                      _canComplete(
                                        appointment,
                                      );

                              return InkWell(
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                                onTap: () {
                                  _showAppointmentDetail(
                                    context,
                                    appointment,
                                  );
                                },
                                child:
                                    AppointmentRequestCard(
                                  appointment:
                                      appointment,

                                  // ===============================
                                  // ACCEPT
                                  // ===============================

                                  onAccept:
                                      status ==
                                              "pending"
                                          ? () =>
                                              _updateStatus(
                                                appointment
                                                    .id,
                                                "accepted",
                                              )
                                          : null,

                                  // ===============================
                                  // REJECT
                                  // ===============================

                                  onReject:
                                      status ==
                                              "pending"
                                          ? () =>
                                              _rejectAppointment(
                                                appointment
                                                    .id,
                                              )
                                          : null,

                                  // ===============================
                                  // COMPLETE
                                  // ===============================

                                  canComplete:
                                      canComplete,

                                  onComplete:
                                      canComplete
                                          ? () =>
                                              _updateStatus(
                                                appointment
                                                    .id,
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
      backgroundColor: AppColors.white,
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

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    await _updateStatus(
      appointmentId,
      "rejected",
      reason: reason.trim(),
    );
  }

  // =========================================================
  // FILTER
  // =========================================================

  List<AppointmentModel>
      _filterAppointments(
    List<AppointmentModel> appointments,
  ) {
    if (selectedStatus == "all") {
      return appointments;
    }

    return appointments
        .where(
          (appointment) =>
              appointment.status
                  .toLowerCase() ==
              selectedStatus.toLowerCase(),
        )
        .toList();
  }

  // =========================================================
  // CAN COMPLETE
  //
  // Chỉ Complete khi Appointment đã kết thúc.
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

  Future<void> _updateStatus(
    String appointmentId,
    String status, {
    String? reason,
  }) async {
    try {
      await _service.updateStatus(
        appointmentId,
        status,
        rejectReason: reason,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _statusMessage(status),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

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