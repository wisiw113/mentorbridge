
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/appointment_model.dart';
import '../../models/appointment_rating_model.dart';

import '../../services/appointment_service.dart';
import '../../services/appointment_rating_service.dart';
import '../../services/user_profile_service.dart';

import '../../widgets/appointment/detail/appointment_user_card.dart';
import '../../widgets/appointment/detail/appointment_status_card.dart';
import '../../widgets/appointment/detail/appointment_info_card.dart';
import '../../widgets/appointment/detail/appointment_schedule_card.dart';
import '../../widgets/appointment/detail/appointment_reason_card.dart';
import '../../widgets/appointment/detail/appointment_action_buttons.dart';
import '../../widgets/appointment/detail/appointment_rating_card.dart';

import '../mentor/screens/mentee_profile_screen.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final AppointmentModel appointment;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends State<AppointmentDetailScreen> {
  final _appointmentService = AppointmentService();

  final _appointmentRatingService =
      AppointmentRatingService();

  final _userProfileService =
      UserProfileService();

  late AppointmentModel _appointment;

  // =========================================================
  // OTHER USER PROFILE
  // =========================================================

  String? _otherName;
  String? _otherEmail;
  String? _otherRole;
  String? _otherBio;
  String? _otherPhotoURL;

  // =========================================================
  // RATING
  // =========================================================

  AppointmentRatingModel? _rating;

  // =========================================================
  // STATE
  // =========================================================

  bool _isLoading = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    _appointment = widget.appointment;

    _loadOtherUserProfile();
    _checkAutoComplete();
  }

  // =========================================================
  // CURRENT USER
  // =========================================================

  String? get _uid =>
      FirebaseAuth.instance.currentUser?.uid;

  bool get _isMentor =>
      _uid == _appointment.mentorId;

  bool get _isMentee =>
      _uid == _appointment.menteeId;

  // =========================================================
  // OTHER USER ID
  // =========================================================

  String get _otherUserId {
    return _isMentor
        ? _appointment.menteeId
        : _appointment.mentorId;
  }

  // =========================================================
  // DISPLAY ROLE
  // =========================================================

  String get _displayRole {
    if (_otherRole?.toLowerCase() == 'mentor') {
      return 'Mentor';
    }

    if (_otherRole?.toLowerCase() == 'mentee') {
      return 'Mentee';
    }

    // Fallback dựa trên người đang đăng nhập
    if (_isMentor) {
      return 'Mentee';
    }

    if (_isMentee) {
      return 'Mentor';
    }

    return '';
  }

  // =========================================================
  // OPEN MENTEE PROFILE
  // =========================================================

  void _openMenteeProfile() {
    // Chỉ Mentor mới có thể bấm
    // để xem profile của Mentee.
    if (!_isMentor) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenteeProfileScreen(
          menteeId: _appointment.menteeId,
        ),
      ),
    );
  }

  // =========================================================
  // LOAD OTHER USER PROFILE
  // =========================================================

  Future<void> _loadOtherUserProfile() async {
    try {
      final profile =
          await _userProfileService.getUserProfile(
        _otherUserId,
      );

      if (!mounted) return;

      setState(() {
        _otherName =
            profile?['name']?.toString();

        _otherEmail =
            profile?['email']?.toString();

        _otherRole =
            profile?['role']?.toString();

        _otherBio =
            profile?['bio']?.toString();

        _otherPhotoURL =
            profile?['photoURL']?.toString();
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _otherName = null;
        _otherEmail = null;
        _otherRole = null;
        _otherBio = null;
        _otherPhotoURL = null;
      });
    }
  }

  // =========================================================
  // LOAD RATING
  // =========================================================

  Future<void> _loadRating() async {
    if (_appointment.status != 'completed') {
      return;
    }

    try {
      final rating =
          await _appointmentRatingService
              .getRatingByAppointment(
        _appointment.id,
      );

      if (!mounted) return;

      setState(() {
        _rating = rating;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _rating = null;
      });
    }
  }

  // =========================================================
  // CONDITIONS
  // =========================================================

  bool get _canComplete {
    return _isMentor &&
        _appointment.status == 'accepted' &&
        !DateTime.now().isBefore(
          _appointment.startAt,
        );
  }

  bool get _canCancel {
    return (_isMentor || _isMentee) &&
        (_appointment.status == 'pending' ||
            _appointment.status == 'accepted');
  }

  // =========================================================
  // AUTO COMPLETE
  // =========================================================

  Future<void> _checkAutoComplete() async {
    if (_appointment.status == 'completed') {
      await _loadRating();
      return;
    }

    if (_appointment.status != 'accepted') {
      return;
    }

    final updated =
        await _appointmentService
            .autoCompleteIfNeeded(
      _appointment,
    );

    if (!mounted) return;

    setState(() {
      _appointment = updated;
    });

    if (updated.status == 'completed') {
      await _loadRating();
    }
  }

  // =========================================================
  // ACCEPT
  // =========================================================

  Future<void> _acceptAppointment() async {
    await _runAction(
      () => _appointmentService.acceptAppointment(
        _appointment.id,
      ),
      () {
        _appointment =
            _appointment.copyWith(
          status: 'accepted',
        );
      },
      'Đã chấp nhận Appointment.',
    );
  }

  // =========================================================
  // REJECT
  // =========================================================

  Future<void> _rejectAppointment() async {
    final reason =
        await _showReasonDialog(
      title: 'Từ chối Appointment',
      hint: 'Nhập lý do từ chối...',
    );

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    await _runAction(
      () => _appointmentService.rejectAppointment(
        appointmentId: _appointment.id,
        reason: reason,
      ),
      () {
        _appointment =
            _appointment.copyWith(
          status: 'rejected',
          rejectReason: reason.trim(),
        );
      },
      'Đã từ chối Appointment.',
    );
  }

  // =========================================================
  // CANCEL
  // =========================================================

  Future<void> _cancelAppointment() async {
    final reason =
        await _showReasonDialog(
      title: 'Hủy Appointment',
      hint: 'Nhập lý do hủy Appointment...',
    );

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    await _runAction(
      () => _appointmentService.cancelAppointment(
        appointmentId: _appointment.id,
        reason: reason,
      ),
      () {
        _appointment =
            _appointment.copyWith(
          status: 'cancelled',
          cancelReason: reason.trim(),
        );
      },
      'Đã hủy Appointment.',
    );
  }

  // =========================================================
  // COMPLETE
  // =========================================================

  Future<void> _completeAppointment() async {
    await _runAction(
      () => _appointmentService.completeAppointment(
        _appointment,
      ),
      () {
        _appointment =
            _appointment.copyWith(
          status: 'completed',
        );
      },
      'Appointment đã hoàn thành.',
    );

    if (_appointment.status == 'completed') {
      await _loadRating();
    }
  }

  // =========================================================
  // ACTION HELPER
  // =========================================================

  Future<void> _runAction(
    Future<void> Function() action,
    VoidCallback update,
    String message,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await action();

      if (!mounted) return;

      setState(() {
        update();
        _isLoading = false;
      });

      _showMessage(message);
    } catch (e) {
      _handleError(e);
    }
  }

  // =========================================================
  // REASON DIALOG
  // =========================================================

  Future<String?> _showReasonDialog({
    required String title,
    required String hint,
  }) async {
    final controller =
        TextEditingController();

    final result =
        await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              border:
                  const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text.trim(),
                );
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
  }

  // =========================================================
  // ERROR
  // =========================================================

  void _handleError(Object error) {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _showMessage(
      error.toString().replaceFirst(
            'Exception: ',
            '',
          ),
      isError: true,
    );
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red : null,
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final status = _appointment.status;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Detail',
        ),
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [

                  // =================================================
                  // OTHER USER
                  // =================================================

                  AppointmentUserCard(
                    name: _otherName ?? 'Unknown',
                    email: _otherEmail ?? '',
                    role: _displayRole,
                    bio: _otherBio ?? '',
                    photoURL: _otherPhotoURL,

                    // =================================================
                    // CHỈ MENTOR MỚI BẤM ĐƯỢC
                    // ĐỂ XEM MENTEE PROFILE
                    // =================================================

                    onTap: _isMentor
                        ? _openMenteeProfile
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // STATUS
                  // =================================================

                  AppointmentStatusCard(
                    status: status,
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // INFORMATION
                  // =================================================

                  AppointmentInfoCard(
                    date: _appointment.date,
                    time: _appointment.time,
                    topic: _appointment.topic,
                    note: _appointment.note,
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // SCHEDULE
                  // =================================================

                  AppointmentScheduleCard(
                    startAt: _appointment.startAt,
                    endAt: _appointment.endAt,
                  ),

                  // =================================================
                  // RATING
                  // =================================================

                  if (status == 'completed' &&
                      _rating != null)
                    AppointmentRatingCard(
                      rating: _rating!.rating,
                      comment: _rating!.comment,
                    ),

                  // =================================================
                  // REJECT REASON
                  // =================================================

                  if (status == 'rejected' &&
                      _appointment.rejectReason != null)
                    AppointmentReasonCard(
                      title: 'Reason for rejection',
                      reason:
                          _appointment.rejectReason!,
                    ),

                  // =================================================
                  // CANCEL REASON
                  // =================================================

                  if (status == 'cancelled' &&
                      _appointment.cancelReason != null)
                    AppointmentReasonCard(
                      title: 'Reason for cancellation',
                      reason:
                          _appointment.cancelReason!,
                    ),

                  const SizedBox(height: 24),

                  // =================================================
                  // ACTIONS
                  // =================================================

                  AppointmentActionButtons(
                    isMentor: _isMentor,
                    canComplete: _canComplete,
                    canCancel: _canCancel,
                    status: status,
                    onAccept: _acceptAppointment,
                    onReject: _rejectAppointment,
                    onComplete: _completeAppointment,
                    onCancel: _cancelAppointment,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}

