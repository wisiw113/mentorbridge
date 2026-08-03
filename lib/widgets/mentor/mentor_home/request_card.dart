import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/appointment_model.dart';
import '../../../../services/appointment_service.dart';

class RequestCard extends StatelessWidget {
  final List<AppointmentModel> requests;

  const RequestCard({
    super.key,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    final pendingRequests = requests
        .where(
          (request) => request.status == "pending",
        )
        .toList();

    if (pendingRequests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: AppColors.deepGreen,
                ),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    "Connection Requests",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.red,
                  child: Text(
                    pendingRequests.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ...pendingRequests.take(3).map(
              (appointment) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: RequestItem(
                  appointment: appointment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// REQUEST ITEM
// =============================================================

class RequestItem extends StatefulWidget {
  final AppointmentModel appointment;

  const RequestItem({
    super.key,
    required this.appointment,
  });

  @override
  State<RequestItem> createState() =>
      _RequestItemState();
}

class _RequestItemState
    extends State<RequestItem> {
  final AppointmentService _service =
      AppointmentService();

  bool _isLoading = false;

  // ===========================================================
  // ACCEPT
  // ===========================================================

  Future<void> _acceptAppointment() async {
    if (_isLoading) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      await _service.acceptAppointment(
        widget.appointment.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Đã chấp nhận yêu cầu.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Không thể chấp nhận yêu cầu: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ===========================================================
  // REJECT
  // ===========================================================

  Future<void> _rejectAppointment() async {
    if (_isLoading) {
      return;
    }

    final reason = await _showReasonDialog();

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      await _service.rejectAppointment(
        appointmentId:
            widget.appointment.id,
        reason: reason.trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Đã từ chối yêu cầu.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Không thể từ chối yêu cầu: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ===========================================================
  // REASON DIALOG
  // ===========================================================

  Future<String?> _showReasonDialog() async {
    final controller =
        TextEditingController();

    final result =
        await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Từ chối Appointment",
          ),

          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  "Nhập lý do từ chối...",
              border:
                  OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                "Hủy",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final reason =
                    controller.text.trim();

                if (reason.isEmpty) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  reason,
                );
              },
              child: const Text(
                "Xác nhận",
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final appointment =
        widget.appointment;

    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            appointment.menteeName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            appointment.topic,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
              ),

              const SizedBox(width: 6),

              Text(
                appointment.date,
              ),

              const SizedBox(width: 16),

              const Icon(
                Icons.access_time,
                size: 16,
              ),

              const SizedBox(width: 6),

              Text(
                appointment.time,
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_isLoading)
            const Center(
              child:
                  CircularProgressIndicator(),
            )
          else
            Row(
              children: [
                // =================================================
                // REJECT
                // =================================================

                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _rejectAppointment,
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          Colors.red,
                    ),
                    child: const Text(
                      "Reject",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // =================================================
                // ACCEPT
                // =================================================

                Expanded(
                  child:
                      ElevatedButton(
                    onPressed:
                        _acceptAppointment,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.mintGreen,
                      foregroundColor:
                          Colors.white,
                    ),
                    child: const Text(
                      "Accept",
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}