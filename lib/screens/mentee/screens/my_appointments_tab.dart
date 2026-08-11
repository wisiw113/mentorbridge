import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/services/appointment_service.dart';

class MyAppointmentsTab extends StatelessWidget {
  MyAppointmentsTab({super.key});

  final AppointmentService _service =
      AppointmentService();

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    // =========================================================
    // CHƯA ĐĂNG NHẬP
    // =========================================================

    if (user == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient:
              AppColors.backgroundGradient,
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

    // =========================================================
    // APPOINTMENTS
    // =========================================================

    return Container(
      width: double.infinity,
      height: double.infinity,

      // =======================================================
      // DÙNG MÀU NỀN GRADIENT CỦA APP
      // =======================================================

      decoration: const BoxDecoration(
        gradient:
            AppColors.backgroundGradient,
      ),

      child: StreamBuilder<
          List<AppointmentModel>>(
        stream:
            _service.getMenteeAppointments(
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
              child:
                  CircularProgressIndicator(
                color:
                    AppColors.mintGreen,
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
                  "Không thể tải lịch hẹn.\n"
                  "${snapshot.error}",
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    color:
                        AppColors.error,
                  ),
                ),
              ),
            );
          }

          // ===================================================
          // EMPTY
          // ===================================================

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có lịch hẹn",
                style: TextStyle(
                  color:
                      AppColors.darkGray,
                  fontSize: 15,
                ),
              ),
            );
          }

          final list =
              snapshot.data!;

          // ===================================================
          // LIST
          // ===================================================

          return ListView.builder(
            padding:
                const EdgeInsets.only(
              top: 12,
              bottom: 110,
            ),

            itemCount:
                list.length,

            itemBuilder:
                (context, index) {
              final item =
                  list[index];

              // =================================================
              // STATUS COLOR
              // =================================================

              Color statusColor;

              switch (
                  item.status
                      .toLowerCase()) {
                case "accepted":
                  statusColor =
                      AppColors.accepted;
                  break;

                case "rejected":
                  statusColor =
                      AppColors.error;
                  break;

                case "completed":
                  statusColor =
                      AppColors.completed;
                  break;

                case "cancelled":
                  statusColor =
                      AppColors.cancelled;
                  break;

                case "pending":
                default:
                  statusColor =
                      AppColors.pending;
                  break;
              }

              // =================================================
              // APPOINTMENT CARD
              // =================================================

              return Card(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),

                color:
                    AppColors.cardBackground,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  side: const BorderSide(
                    color:
                        AppColors.border,
                  ),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    4,
                  ),

                  child: ListTile(
                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    // =================================================
                    // ICON
                    // =================================================

                    leading: Container(
                      width: 46,
                      height: 46,

                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .lightMint,
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons
                            .calendar_today_rounded,
                        color:
                            AppColors
                                .mintGreen,
                      ),
                    ),

                    // =================================================
                    // MENTOR
                    // =================================================

                    title: Text(
                      "Mentor: ${item.mentorName}",

                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            AppColors
                                .titleText,
                      ),
                    ),

                    // =================================================
                    // DETAILS
                    // =================================================

                    subtitle:
                        Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 8,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          // DATE
                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .calendar_month_outlined,
                                size: 16,
                                color:
                                    AppColors
                                        .iconSecondary,
                              ),

                              const SizedBox(
                                width: 7,
                              ),

                              Expanded(
                                child: Text(
                                  "Ngày: ${item.date}",
                                  style:
                                      const TextStyle(
                                    color:
                                        AppColors
                                            .darkGray,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          // TIME
                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .schedule_outlined,
                                size: 16,
                                color:
                                    AppColors
                                        .iconSecondary,
                              ),

                              const SizedBox(
                                width: 7,
                              ),

                              Expanded(
                                child: Text(
                                  "Giờ: ${item.time}",
                                  style:
                                      const TextStyle(
                                    color:
                                        AppColors
                                            .darkGray,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          // NOTE
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Icon(
                                Icons
                                    .notes_outlined,
                                size: 16,
                                color:
                                    AppColors
                                        .iconSecondary,
                              ),

                              const SizedBox(
                                width: 7,
                              ),

                              Expanded(
                                child: Text(
                                  "Ghi chú: ${item.note.isEmpty ? "-" : item.note}",
                                  style:
                                      const TextStyle(
                                    color:
                                        AppColors
                                            .darkGray,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          // =================================================
                          // STATUS
                          // =================================================

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  statusColor
                                      .withOpacity(
                                0.10,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),

                            child: Text(
                              "Trạng thái: ${item.status}",

                              style:
                                  TextStyle(
                                color:
                                    statusColor,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}