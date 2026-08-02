
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/models/appointment_rating_model.dart';

import 'package:flutter_application_1/services/appointment_service.dart';
import 'package:flutter_application_1/services/appointment_rating_service.dart';

import 'package:flutter_application_1/widgets/mentee/mentee_appointment_tab/appointment_card.dart';
import 'package:flutter_application_1/widgets/appointment/appointment_detail_popup.dart';

import 'package:flutter_application_1/widgets/common/rating_popup.dart';

import 'package:flutter_application_1/widgets/mentee/mentee_appointment_tab/pending_filter_bar.dart';
import 'package:flutter_application_1/widgets/mentee/mentee_appointment_tab/pending_sort_bar.dart';
import 'package:flutter_application_1/widgets/mentee/mentee_appointment_tab/pending_empty_state.dart';

class PendingTab extends StatefulWidget {
  const PendingTab({
    super.key,
  });

  @override
  State<PendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab> {
  final AppointmentService _appointmentService =
      AppointmentService();

  final AppointmentRatingService _ratingService =
      AppointmentRatingService();

  final TextEditingController _searchController =
      TextEditingController();

  // =========================================================
  // SEARCH
  // =========================================================

  String _searchText = '';

  // =========================================================
  // FILTER + SORT
  // =========================================================

  String _selectedStatus = 'all';

  String _selectedSort = 'nearest';

  // =========================================================
  // FIRESTORE STREAM
  // Tạo 1 lần duy nhất.
  // Không tạo lại stream mỗi khi search.
  // =========================================================

  Stream<List<AppointmentModel>>? _appointmentsStream;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _appointmentsStream =
          _appointmentService.getMenteeAppointments(
        user.uid,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // FILTER + SEARCH + SORT
  // =========================================================

  List<AppointmentModel> _filterAndSortAppointments(
    List<AppointmentModel> appointments,
  ) {
    final search = _searchText;

    final filtered = appointments.where((appointment) {
      // =====================================================
      // STATUS
      // =====================================================

      final status = appointment.status.toLowerCase();

      final matchStatus =
          _selectedStatus == 'all' ||
          status == _selectedStatus;

      // =====================================================
      // SEARCH
      // =====================================================

      final matchSearch =
          search.isEmpty ||
          appointment.mentorName
              .toLowerCase()
              .contains(search) ||
          appointment.topic
              .toLowerCase()
              .contains(search) ||
          appointment.note
              .toLowerCase()
              .contains(search) ||
          appointment.date
              .toLowerCase()
              .contains(search);

      return matchStatus && matchSearch;
    }).toList();

    // =======================================================
    // SORT
    // =======================================================

    switch (_selectedSort) {
      // Lịch gần nhất trước
      case 'nearest':
        filtered.sort(
          (a, b) => a.startAt.compareTo(
            b.startAt,
          ),
        );
        break;

      // Lịch xa nhất trước
      case 'farthest':
        filtered.sort(
          (a, b) => b.startAt.compareTo(
            a.startAt,
          ),
        );
        break;

      // Mới tạo gần nhất
      case 'newest':
        filtered.sort(
          (a, b) => b.createdAt.compareTo(
            a.createdAt,
          ),
        );
        break;

      // Tạo lâu nhất
      case 'oldest':
        filtered.sort(
          (a, b) => a.createdAt.compareTo(
            b.createdAt,
          ),
        );
        break;
    }

    return filtered;
  }

  // =========================================================
  // CLEAR FILTER
  // =========================================================

  void _clearFilter() {
    _searchController.clear();

    setState(() {
      _searchText = '';
      _selectedStatus = 'all';
      _selectedSort = 'nearest';
    });
  }

  // =========================================================
  // CANCEL APPOINTMENT
  // =========================================================

  Future<void> _cancelAppointment(
    BuildContext context,
    AppointmentModel appointment,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Hủy lịch hẹn',
          ),
          content: const Text(
            'Bạn có chắc chắn muốn hủy lịch hẹn này không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Không',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Hủy lịch',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      await _appointmentService.cancelAppointment(
        appointment.id,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đã hủy lịch hẹn.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể hủy lịch: $e',
          ),
        ),
      );
    }
  }

  // =========================================================
  // APPOINTMENT DETAIL
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
  // RATING
  // =========================================================

  Future<void> _showRatingDialog(
    BuildContext context,
    AppointmentModel appointment,
    String menteeId,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const RatingPopup(),
    );

    // Người dùng bấm Hủy
    if (result == null) {
      return;
    }

    final ratingValue = result['rating'];
    final commentValue = result['comment'];

    if (ratingValue == null) {
      return;
    }

    final int rating = ratingValue is int
        ? ratingValue
        : int.tryParse(
              ratingValue.toString(),
            ) ??
            0;

    final String comment =
        commentValue?.toString().trim() ?? '';

    if (rating < 1 || rating > 5) {
      return;
    }

    try {
      // =====================================================
      // CHECK ALREADY RATED
      // =====================================================

      final alreadyRated =
          await _ratingService.hasRated(
        appointmentId: appointment.id,
        menteeId: menteeId,
      );

      if (alreadyRated) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bạn đã đánh giá lịch hẹn này rồi.',
            ),
          ),
        );

        return;
      }

      // =====================================================
      // CREATE RATING MODEL
      // =====================================================

      final ratingModel = AppointmentRatingModel(
        id: '',
        mentorId: appointment.mentorId,
        menteeId: appointment.menteeId,
        appointmentId: appointment.id,
        mentorName: appointment.mentorName,
        menteeName: appointment.menteeName,
        rating: rating.toDouble(),
        comment: comment,
        createdAt: DateTime.now(),
      );

      // =====================================================
      // SAVE RATING
      // =====================================================

      await _ratingService.createRating(
        ratingModel,
      );

      // =====================================================
      // UPDATE RATED
      // =====================================================

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.id)
          .update({
        'rated': true,
      });

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cảm ơn bạn đã đánh giá Mentor!',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể đánh giá: $e',
          ),
        ),
      );
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          'Chưa đăng nhập',
        ),
      );
    }

    // =======================================================
    // STREAM ĐÃ ĐƯỢC TẠO TỪ INITSTATE
    // =======================================================

    final stream = _appointmentsStream;

    if (stream == null) {
      return const Center(
        child: Text(
          'Không thể tải lịch hẹn.',
        ),
      );
    }

    return StreamBuilder<List<AppointmentModel>>(
      stream: stream,
      builder: (context, snapshot) {
        // ===================================================
        // LOADING
        // ===================================================

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ===================================================
        // ERROR
        // ===================================================

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Không thể tải lịch hẹn.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // ===================================================
        // ORIGINAL DATA
        // ===================================================

        final appointments = snapshot.data ?? [];

        // ===================================================
        // FILTER + SEARCH + SORT
        //
        // Chỉ xử lý List local.
        // Không gọi Firestore khi người dùng gõ.
        // ===================================================

        final filteredAppointments =
            _filterAndSortAppointments(
          appointments,
        );

        // ===================================================
        // CHECK FILTER
        // ===================================================

        final isFiltered =
            _searchText.isNotEmpty ||
            _selectedStatus != 'all';

        return Column(
          children: [
            // =================================================
            // SEARCH BAR
            // =================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                8,
              ),
              child: TextField(
                controller: _searchController,

                // =================================================
                // SEARCH NGAY LẬP TỨC
                //
                // Không debounce.
                // Không Timer.
                // Không delay.
                // Giống SearchTab.
                // =================================================

                onChanged: (value) {
                  setState(() {
                    _searchText =
                        value.trim().toLowerCase();
                  });
                },

                decoration: InputDecoration(
                  hintText:
                      'Tìm Mentor, chủ đề, ghi chú...',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),

                  // =================================================
                  // CLEAR SEARCH
                  // =================================================

                  suffixIcon:
                      _searchText.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();

                                setState(() {
                                  _searchText = '';
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                              ),
                            )
                          : null,

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // =================================================
            // FILTER BAR
            // =================================================

            PendingFilterBar(
              selectedStatus: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),

            // =================================================
            // SORT BAR
            // =================================================

            PendingSortBar(
              selectedSort: _selectedSort,
              onChanged: (value) {
                setState(() {
                  _selectedSort = value;
                });
              },
            ),

            // =================================================
            // LIST
            // =================================================

            Expanded(
              child: filteredAppointments.isEmpty
                  ? PendingEmptyState(
                      isFiltered: isFiltered,
                      onClearFilter: isFiltered
                          ? _clearFilter
                          : null,
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(
                        0,
                        4,
                        0,
                        30,
                      ),
                      itemCount:
                          filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment =
                            filteredAppointments[index];

                        final status =
                            appointment.status
                                .toLowerCase();

                        // =================================================
                        // CAN CANCEL
                        // =================================================

                        final canCancel =
                            status == 'pending' ||
                            status == 'accepted';

                        // =================================================
                        // CAN RATE
                        // =================================================

                        final canRate =
                            status == 'completed' &&
                            !appointment.rated;

                        return GestureDetector(
                          onTap: () {
                            _showAppointmentDetail(
                              context,
                              appointment,
                            );
                          },
                          child: AppointmentCard(
                            appointment: appointment,

                            // Hủy lịch
                            onCancel: canCancel
                                ? () {
                                    _cancelAppointment(
                                      context,
                                      appointment,
                                    );
                                  }
                                : null,

                            // Đánh giá
                            onRate: canRate
                                ? () {
                                    _showRatingDialog(
                                      context,
                                      appointment,
                                      user.uid,
                                    );
                                  }
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

