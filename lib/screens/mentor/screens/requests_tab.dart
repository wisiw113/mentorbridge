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
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  final AppointmentService _service = AppointmentService();


    String selectedStatus = "all";
    void _showAppointmentDetail(
    BuildContext context,
    AppointmentModel appointment,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return AppointmentDetailPopup(
          appointment: appointment,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
      child: StreamBuilder<List<AppointmentModel>>(
        stream: _service.getMentorRequests(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mintGreen,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Không thể tải yêu cầu.\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                ),
              ),
            );
          }

          final appointments = snapshot.data ?? [];
          final filteredAppointments =
              _filterAppointments(appointments);

          return Column(
            children: [
              const SizedBox(height: 16),

              AppointmentStatusFilter(
                selectedStatus: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: filteredAppointments.isEmpty
                    ? const AppointmentEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: 24,
                        ),
                        itemCount:
                            filteredAppointments.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final appointment =
                              filteredAppointments[index];

                          return InkWell(
  borderRadius: BorderRadius.circular(14),
  onTap: () {
    _showAppointmentDetail(
      context,
      appointment,
    );
  },
  child: AppointmentRequestCard(
    appointment: appointment,

    onAccept: () => _updateStatus(
      appointment.id,
      "accepted",
    ),

    onReject: () =>
        _rejectAppointment(
      appointment.id,
    ),

    onComplete: _canComplete(
      appointment.createdAt,
    )
        ? () => _updateStatus(
              appointment.id,
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

  Future<void> _rejectAppointment(
    String appointmentId,
  ) async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return const RejectReasonPopup();
      },
    );

    if (reason == null) return;

    await _updateStatus(
      appointmentId,
      "rejected",
      reason: reason,
    );
  }

  List<AppointmentModel> _filterAppointments(
    List<AppointmentModel> appointments,
  ) {
    if (selectedStatus == "all") {
      return appointments;
    }

    return appointments
        .where(
          (appointment) =>
              appointment.status.toLowerCase() ==
              selectedStatus.toLowerCase(),
        )
        .toList();
  }

  bool _canComplete(DateTime createdAt) {
    return DateTime.now().isAfter(
      createdAt.add(
        const Duration(minutes: 5),
      ),
    );
  }

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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _statusMessage(status),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Có lỗi xảy ra: $e",
          ),
        ),
      );
    }
  }

  String _statusMessage(String status) {
    switch (status) {
      case "accepted":
        return "Đã chấp nhận yêu cầu.";

      case "rejected":
        return "Đã từ chối yêu cầu.";

      case "completed":
        return "Session đã hoàn thành.";

      default:
        return "Đã cập nhật trạng thái.";
    }
  }
}