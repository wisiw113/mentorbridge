import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =========================================================
  // CREATE APPOINTMENT
  // =========================================================

  Future<void> createAppointment(
    AppointmentModel appointment,
  ) async {
    await _firestore
        .collection('appointments')
        .add(
          appointment.toMap(),
        );
  }

  // =========================================================
  // BOOK APPOINTMENT
  // =========================================================

  Future<void> bookAppointment(
    AppointmentModel appointment,
  ) async {
    final now = DateTime.now();

    // Không cho đặt lịch trong quá khứ
    if (appointment.startAt.isBefore(now)) {
      throw Exception(
        'Không thể đặt lịch trong quá khứ.',
      );
    }

    // =======================================================
    // CHECK MENTOR SCHEDULE
    // =======================================================

    final mentorAppointments =
        await _firestore
            .collection('appointments')
            .where(
              'mentorId',
              isEqualTo:
                  appointment.mentorId,
            )
            .where(
              'status',
              whereIn: [
                'pending',
                'accepted',
              ],
            )
            .get();

    for (final doc
        in mentorAppointments.docs) {
      final existing =
          AppointmentModel.fromMap(
        doc.id,
        doc.data(),
      );

      if (_isTimeOverlapping(
        appointment.startAt,
        appointment.endAt,
        existing.startAt,
        existing.endAt,
      )) {
        throw Exception(
          'Mentor đã có lịch hẹn trong khoảng thời gian này.',
        );
      }
    }

    // =======================================================
    // CHECK MENTEE SCHEDULE
    // =======================================================

    final menteeAppointments =
        await _firestore
            .collection('appointments')
            .where(
              'menteeId',
              isEqualTo:
                  appointment.menteeId,
            )
            .where(
              'status',
              whereIn: [
                'pending',
                'accepted',
              ],
            )
            .get();

    for (final doc
        in menteeAppointments.docs) {
      final existing =
          AppointmentModel.fromMap(
        doc.id,
        doc.data(),
      );

      if (_isTimeOverlapping(
        appointment.startAt,
        appointment.endAt,
        existing.startAt,
        existing.endAt,
      )) {
        throw Exception(
          'Bạn đã có một lịch hẹn khác trong khoảng thời gian này.',
        );
      }
    }

    // =======================================================
    // CREATE
    // =======================================================

    await createAppointment(
      appointment,
    );
  }

  // =========================================================
  // CHECK OVERLAP
  // =========================================================

  bool _isTimeOverlapping(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    return start1.isBefore(end2) &&
        end1.isAfter(start2);
  }

  // =========================================================
  // GET APPOINTMENT BY ID
  // =========================================================

  Future<AppointmentModel?> getAppointment(
    String appointmentId,
  ) async {
    final doc = await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();

    if (data == null) {
      return null;
    }

    return AppointmentModel.fromMap(
      doc.id,
      data,
    );
  }

  // =========================================================
  // GET MENTEE APPOINTMENTS
  // =========================================================

  Stream<List<AppointmentModel>>
      getMenteeAppointments(
    String menteeId,
  ) {
    return _firestore
        .collection('appointments')
        .where(
          'menteeId',
          isEqualTo: menteeId,
        )
        .snapshots()
        .map(
      (snapshot) {
        final appointments =
            snapshot.docs
                .map(
                  (doc) =>
                      AppointmentModel
                          .fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();

        _sortAppointments(
          appointments,
        );

        return appointments;
      },
    );
  }

  // =========================================================
  // GET MENTOR APPOINTMENTS
  // =========================================================

  Stream<List<AppointmentModel>>
      getMentorAppointments(
    String mentorId,
  ) {
    return _firestore
        .collection('appointments')
        .where(
          'mentorId',
          isEqualTo: mentorId,
        )
        .snapshots()
        .map(
      (snapshot) {
        final appointments =
            snapshot.docs
                .map(
                  (doc) =>
                      AppointmentModel
                          .fromMap(
                    doc.id,
                    doc.data(),
                  ),
                )
                .toList();

        _sortAppointments(
          appointments,
        );

        return appointments;
      },
    );
  }

  // =========================================================
  // SORT APPOINTMENTS
  // =========================================================

  void _sortAppointments(
    List<AppointmentModel>
        appointments,
  ) {
    appointments.sort(
      (a, b) =>
          a.startAt.compareTo(
        b.startAt,
      ),
    );
  }

  // =========================================================
  // ACCEPT APPOINTMENT
  // =========================================================

  Future<void> acceptAppointment(
    String appointmentId,
  ) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'status': 'accepted',
      'rejectReason': null,
    });
  }

  // =========================================================
  // REJECT APPOINTMENT
  // =========================================================

  Future<void> rejectAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    final trimmedReason =
        reason.trim();

    if (trimmedReason.isEmpty) {
      throw Exception(
        'Vui lòng nhập lý do từ chối.',
      );
    }

    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'status': 'rejected',
      'rejectReason':
          trimmedReason,
    });
  }

  // =========================================================
  // CANCEL APPOINTMENT
  // =========================================================

  Future<void> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    final trimmedReason =
        reason.trim();

    if (trimmedReason.isEmpty) {
      throw Exception(
        'Vui lòng nhập lý do hủy lịch.',
      );
    }

    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'status': 'cancelled',
      'cancelReason':
          trimmedReason,
    });
  }

  // =========================================================
  // COMPLETE APPOINTMENT
  // =========================================================
  //
  // Chỉ cho phép Mentor Complete
  // khi thời gian hiện tại >= startAt.
  //
  // Không được Complete trước giờ bắt đầu.

  Future<void> completeAppointment(
    AppointmentModel appointment,
  ) async {
    final now =
        DateTime.now();

    if (appointment.status !=
        'accepted') {
      throw Exception(
        'Appointment chưa ở trạng thái accepted.',
      );
    }

    if (now.isBefore(
      appointment.startAt,
    )) {
      throw Exception(
        'Chưa đến thời gian bắt đầu Appointment.',
      );
    }

    await _firestore
        .collection('appointments')
        .doc(appointment.id)
        .update({
      'status': 'completed',
    });
  }

  // =========================================================
  // AUTO COMPLETE
  // =========================================================
  //
  // Firestore không tự chạy code Flutter khi thời gian tới.
  //
  // Vì vậy màn hình sẽ gọi hàm này khi mở Appointment Detail.
  //
  // Nếu:
  //
  // accepted
  // +
  // now >= endAt
  //
  // => chuyển completed.

  Future<AppointmentModel>
      autoCompleteIfNeeded(
    AppointmentModel appointment,
  ) async {
    final now =
        DateTime.now();

    if (appointment.status ==
            'accepted' &&
        !now.isBefore(
          appointment.endAt,
        )) {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .update({
        'status': 'completed',
      });

      return appointment.copyWith(
        status: 'completed',
      );
    }

    return appointment;
  }

  // =========================================================
  // UPDATE RATED
  // =========================================================

  Future<void> updateRated(
    String appointmentId,
  ) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'rated': true,
    });
  }
}  