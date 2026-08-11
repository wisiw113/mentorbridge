
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onCancel,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    final status = appointment.status.toLowerCase();

    return Card(
      margin: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8,
      ),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // MENTOR AVATAR
                  // =================================================

                  FutureBuilder<
                      DocumentSnapshot<
                          Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(appointment.mentorId)
                        .get(),
                    builder: (
                      context,
                      snapshot,
                    ) {
                      final data =
                          snapshot.data?.data();

                      final photoURL =
                          data?['photoURL']
                                  ?.toString()
                                  .trim() ??
                              '';

                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.softMint,
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                        clipBehavior:
                            Clip.antiAlias,
                        child: photoURL.isNotEmpty
                            ? Image.network(
                                photoURL,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return const Icon(
                                    Icons
                                        .person_outline,
                                    color: AppColors
                                        .deepGreen,
                                    size: 25,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person_outline,
                                color:
                                    AppColors.deepGreen,
                                size: 25,
                              ),
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  // =================================================
                  // TOPIC + MENTOR NAME
                  // =================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.topic
                                  .trim()
                                  .isNotEmpty
                              ? appointment.topic
                              : 'Lịch hẹn',
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                AppColors.deepGreen,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 16,
                              color:
                                  AppColors.gray,
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            Expanded(
                              child: Text(
                                appointment.mentorName,
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  fontSize: 13,
                                  color:
                                      AppColors.gray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // =================================================
                  // TRẠNG THÁI
                  // =================================================

                  _StatusBadge(
                    status: status,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(
                height: 1,
              ),

              const SizedBox(height: 14),

              // =====================================================
              // NGÀY
              // =====================================================

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.deepGreen,
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      appointment.date,
                      style: const TextStyle(
                        fontSize: 13,
                        color:
                            AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // =====================================================
              // THỜI GIAN
              // =====================================================

              Row(
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                    size: 18,
                    color: AppColors.warning,
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      appointment.time,
                      style: const TextStyle(
                        fontSize: 13,
                        color:
                            AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),

              // =====================================================
              // GHI CHÚ
              // =====================================================

              if (appointment.note
                  .trim()
                  .isNotEmpty) ...[
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notes_outlined,
                      size: 18,
                      color: AppColors.gray,
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: Text(
                        appointment.note,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          fontSize: 13,
                          color:
                              AppColors.gray,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // =====================================================
              // LÝ DO TỪ CHỐI
              // =====================================================

              if (status == 'rejected' &&
                  appointment.rejectReason !=
                      null &&
                  appointment.rejectReason!
                      .trim()
                      .isNotEmpty) ...[
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(12),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.error
                            .withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color:
                            AppColors.error,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          'Lý do từ chối: ${appointment.rejectReason}',
                          style:
                              const TextStyle(
                            fontSize: 13,
                            color: AppColors
                                .darkGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // =====================================================
              // NÚT THAO TÁC
              // =====================================================

              if (onCancel != null ||
                  onRate != null) ...[
                const SizedBox(height: 16),

                Row(
                  children: [
                    // =================================================
                    // HỦY LỊCH
                    // =================================================

                    if (onCancel != null)
                      Expanded(
                        child:
                            OutlinedButton.icon(
                          onPressed: onCancel,
                          icon: const Icon(
                            Icons
                                .cancel_outlined,
                            size: 18,
                          ),
                          label: const Text(
                            'Hủy lịch',
                          ),
                          style:
                              OutlinedButton
                                  .styleFrom(
                            foregroundColor:
                                AppColors
                                    .error,
                            side: BorderSide(
                              color: AppColors
                                  .error
                                  .withValues(
                                alpha: 0.5,
                              ),
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
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),

                    if (onCancel != null &&
                        onRate != null)
                      const SizedBox(
                        width: 10,
                      ),

                    // =================================================
                    // ĐÁNH GIÁ
                    // =================================================

                    if (onRate != null)
                      Expanded(
                        child:
                            ElevatedButton.icon(
                          onPressed: onRate,
                          icon: const Icon(
                            Icons.star_outline,
                            size: 18,
                          ),
                          label: const Text(
                            'Đánh giá',
                          ),
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                AppColors
                                    .deepGreen,
                            foregroundColor:
                                Colors.white,
                            elevation: 0,
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
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],

              // =====================================================
              // XEM CHI TIẾT
              // =====================================================

              if (onCancel == null &&
                  onRate == null) ...[
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        color:
                            AppColors.deepGreen,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color:
                          AppColors.deepGreen,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// HIỂN THỊ TRẠNG THÁI
// =============================================================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    late Color backgroundColor;
    late Color textColor;
    late String text;

    switch (status) {
      case 'pending':
        backgroundColor =
            Colors.orange.withValues(
          alpha: 0.12,
        );
        textColor =
            Colors.orange.shade800;
        text = 'Đang chờ';
        break;

      case 'accepted':
        backgroundColor =
            AppColors.softMint;
        textColor =
            AppColors.deepGreen;
        text = 'Đã chấp nhận';
        break;

      case 'rejected':
        backgroundColor =
            AppColors.error.withValues(
          alpha: 0.10,
        );
        textColor = AppColors.error;
        text = 'Đã từ chối';
        break;

      case 'completed':
      case 'complete':
        backgroundColor =
            Colors.blue.withValues(
          alpha: 0.10,
        );
        textColor =
            Colors.blue.shade700;
        text = 'Đã hoàn thành';
        break;

      case 'cancelled':
      case 'canceled':
        backgroundColor =
            Colors.grey.withValues(
          alpha: 0.12,
        );
        textColor =
            Colors.grey.shade700;
        text = 'Đã hủy';
        break;

      default:
        backgroundColor =
            Colors.grey.withValues(
          alpha: 0.12,
        );
        textColor =
            Colors.grey.shade700;
        text = status;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight:
              FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

