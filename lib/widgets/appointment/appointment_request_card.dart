
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/appointment_model.dart';
import '../../models/rating_model.dart';
import '../../services/appointment_service.dart';

class AppointmentRequestCard extends StatelessWidget {
  final AppointmentModel appointment;

  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  final bool canComplete;

  const AppointmentRequestCard({
    super.key,
    required this.appointment,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.canComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.black,
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =================================================
            // HEADER
            // =================================================

            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Colors.green.shade50,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.green.shade700,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
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
                        "Appointment Request",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildStatusBadge(),
              ],
            ),

            const SizedBox(height: 18),

            // =================================================
            // DATE
            // =================================================

            _InfoRow(
              icon:
                  Icons.calendar_today_outlined,
              label: "Ngày",
              value: appointment.date,
            ),

            const SizedBox(height: 10),

            // =================================================
            // TIME
            // =================================================

            _InfoRow(
              icon:
                  Icons.access_time_outlined,
              label: "Thời gian",
              value: appointment.time,
            ),

            // =================================================
            // TOPIC
            // =================================================

            if (appointment.topic
                .trim()
                .isNotEmpty) ...[
              const SizedBox(height: 10),

              _InfoRow(
                icon:
                    Icons.topic_outlined,
                label: "Chủ đề",
                value: appointment.topic,
              ),
            ],

            // =================================================
            // NOTE
            // =================================================

            if (appointment.note
                .trim()
                .isNotEmpty) ...[
              const SizedBox(height: 10),

              _InfoRow(
                icon:
                    Icons.notes_outlined,
                label: "Ghi chú",
                value: appointment.note,
              ),
            ],

            // =================================================
            // REJECT REASON
            // =================================================

            if (appointment.status ==
                    "rejected" &&
                appointment.rejectReason !=
                    null &&
                appointment.rejectReason!
                    .trim()
                    .isNotEmpty) ...[
              const SizedBox(height: 14),

              _InfoRow(
                icon:
                    Icons.info_outline,
                label: "Lý do",
                value:
                    appointment.rejectReason!,
              ),
            ],

            // =================================================
            // RATING
            // =================================================

            if (appointment.status ==
                "completed") ...[
              const SizedBox(height: 14),

              FutureBuilder<RatingModel?>(
                future:
                    AppointmentService()
                        .getRatingByAppointment(
                  appointment.id,
                ),
                builder:
                    (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors
                                .grey
                                .shade400,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Đang tải đánh giá...",
                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    return Row(
                      children: [
                        Icon(
                          Icons
                              .error_outline,
                          color: Colors
                              .grey
                              .shade400,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Không thể tải đánh giá",
                          style:
                              TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }

                  final rating =
                      snapshot.data;

                  // Chưa có rating
                  if (rating == null) {
                    return Row(
                      children: [
                        Icon(
                          Icons.star_border,
                          color: Colors
                              .grey
                              .shade400,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Chưa đánh giá",
                          style:
                              TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }

                  // Có rating
                  return Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Text(
                        "${rating.rating}/5",
                        style:
                            const TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Row(
                        children:
                            List.generate(
                          5,
                          (index) =>
                              Icon(
                            index <
                                    rating
                                        .rating
                                        .round()
                                ? Icons.star
                                : Icons
                                    .star_border,
                            color:
                                Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],

            // =================================================
            // PENDING ACTIONS
            // =================================================

            if (appointment.status ==
                "pending") ...[
              const SizedBox(height: 18),

              Row(
                children: [
                  // =========================
                  // REJECT
                  // =========================

                  Expanded(
                    child:
                        OutlinedButton(
                      onPressed:
                          onReject,
                      style:
                          OutlinedButton
                              .styleFrom(
                        foregroundColor:
                            Colors.red,
                        side:
                            const BorderSide(
                          color:
                              Colors.red,
                        ),
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 12,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),
                      ),
                      child:
                          const Text(
                        "Reject",
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  // =========================
                  // ACCEPT
                  // =========================

                  Expanded(
                    child:
                        ElevatedButton(
                      onPressed:
                          onAccept,
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.green,
                        foregroundColor:
                            Colors.white,
                        disabledBackgroundColor:
                            Colors.grey
                                .shade300,
                        disabledForegroundColor:
                            Colors.grey
                                .shade600,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 12,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),
                      ),
                      child:
                          const Text(
                        "Accept",
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // =================================================
            // COMPLETE
            // =================================================

            if (appointment.status ==
                "accepted") ...[
              const SizedBox(height: 18),

              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton.icon(
                  onPressed:
                      canComplete
                          ? onComplete
                          : null,
                  icon: const Icon(
                    Icons
                        .check_circle_outline,
                  ),
                  label: Text(
                    canComplete
                        ? "Complete"
                        : "Chưa đến thời gian hoàn thành",
                  ),
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors.green,
                    foregroundColor:
                        Colors.white,
                    disabledBackgroundColor:
                        Colors.grey
                            .shade200,
                    disabledForegroundColor:
                        Colors.grey
                            .shade600,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================
  // STATUS BADGE
  // =========================================================

  Widget _buildStatusBadge() {
    Color color;
    String text;

    switch (appointment.status) {
      case "accepted":
        color = AppColors.accepted;
        text = "Accepted";
        break;

      case "rejected":
        color = AppColors.cancelled;
        text = "Rejected";
        break;

      case "completed":
        color = AppColors.completed;
        text = "Completed";
        break;

      default:
        color = AppColors.pending;
        text = "Pending";
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration:
          BoxDecoration(
        color:
            color.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}

// =========================================================
// INFO ROW
// =========================================================

class _InfoRow
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color:
              Colors.grey.shade600,
        ),

        const SizedBox(width: 10),

        Text(
          "$label: ",
          style: TextStyle(
            color:
                Colors.grey.shade600,
            fontSize: 13,
          ),
        ),

        Expanded(
          child: Text(
            value,
            style:
                const TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

