import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminAppointmentDetailDialog extends StatelessWidget {
  final String appointmentId;

  final String mentorName;
  final String menteeName;

  final String topic;
  final String note;

  final String date;
  final String startTime;
  final String endTime;

  final String status;

  final bool rated;

  final String? rejectReason;
  final String? cancelReason;

  const AdminAppointmentDetailDialog({
    super.key,
    required this.appointmentId,
    required this.mentorName,
    required this.menteeName,
    required this.topic,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.rated,
    this.rejectReason,
    this.cancelReason,
  });

  Color _statusColor() {
    switch (status) {
      case "pending":
        return AppColors.pending;

      case "accepted":
        return AppColors.accepted;

      case "completed":
        return AppColors.completed;

      case "cancelled":
        return AppColors.cancelled;

      case "rejected":
        return AppColors.error;

      default:
        return AppColors.gray;
    }
  }

  String _statusText() {
    switch (status) {
      case "pending":
        return "Pending";

      case "accepted":
        return "Accepted";

      case "completed":
        return "Completed";

      case "cancelled":
        return "Cancelled";

      case "rejected":
        return "Rejected";

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 650,
        ),
        child: Column(
          children: [
            //----------------------------------------------------------
            // HEADER
            //----------------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                10,
                10,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Appointment Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            //----------------------------------------------------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(.12),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusText(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _InfoRow(
                      icon: Icons.school_outlined,
                      label: "Mentor",
                      value: mentorName,
                    ),

                    _InfoRow(
                      icon: Icons.person_outline,
                      label: "Mentee",
                      value: menteeName,
                    ),

                    _InfoRow(
                      icon:
                          Icons.calendar_today_outlined,
                      label: "Date",
                      value: date,
                    ),

                    _InfoRow(
                      icon: Icons.access_time,
                      label: "Time",
                      value:
                          "$startTime - $endTime",
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Topic",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      topic,
                      style: const TextStyle(
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Note",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      note.isEmpty
                          ? "No note."
                          : note,
                    ),

                    if (rejectReason != null &&
                        rejectReason!.isNotEmpty) ...[
                      const SizedBox(height: 20),

                      const Text(
                        "Reject Reason",
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(rejectReason!),
                    ],

                    if (cancelReason != null &&
                        cancelReason!.isNotEmpty) ...[
                      const SizedBox(height: 20),

                      const Text(
                        "Cancel Reason",
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(cancelReason!),
                    ],

                    const SizedBox(height: 24),

                    const Divider(),

                    const SizedBox(height: 12),

                    const Text(
                      "Rating",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (!rated)
                      const Text(
                        "This appointment has not been rated.",
                        style: TextStyle(
                          color: AppColors.gray,
                        ),
                      ),

                    if (rated)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore
                            .instance
                            .collection(
                                "appointment_ratings")
                            .where(
                              "appointmentId",
                              isEqualTo:
                                  appointmentId,
                            )
                            .limit(1)
                            .snapshots(),
                        builder:
                            (context, snapshot) {
                          if (snapshot
                                  .connectionState ==
                              ConnectionState
                                  .waiting) {
                            return const Center(
                              child:
                                  CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot
                                  .data!
                                  .docs
                                  .isEmpty) {
                            return const Text(
                              "Rating not found.",
                            );
                          }

                          final data = snapshot
                                  .data!.docs.first
                                  .data()
                              as Map<String,
                                  dynamic>;

                          final rating =
                              (data["rating"]
                                      as num)
                                  .toDouble();

                          final comment =
                              data["comment"] ??
                                  "";

                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color:
                                        Colors.amber,
                                  ),
                                  const SizedBox(
                                      width: 6),
                                  Text(
                                    rating
                                        .toString(),
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                comment.isEmpty
                                    ? "No comment."
                                    : comment,
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.deepGreen,
            size: 18,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.gray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}