import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/session_model.dart';
import '../models/session_participant_model.dart';
import 'notification_service.dart';

class SessionService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final NotificationService _notificationService =
      NotificationService();

  // =========================================================
  // CREATE SESSION
  // =========================================================

  Future<String> createSession(
    SessionModel session,
  ) async {
    // Không cho tạo Session trong quá khứ
    final newStart =
        _getStartDateTime(session);

    if (!newStart.isAfter(DateTime.now())) {
      throw Exception(
        "Thời gian bắt đầu Session phải ở trong tương lai.",
      );
    }

    // =======================================================
    // CHECK TRÙNG SESSION CỦA MENTOR
    // =======================================================

    final existingSessions =
        await _firestore
            .collection("sessions")
            .where(
              "mentorId",
              isEqualTo: session.mentorId,
            )
            .where(
              "status",
              whereIn: [
                "open",
                "running",
              ],
            )
            .get();

    for (final doc
        in existingSessions.docs) {
      final existing =
          SessionModel.fromMap(
        doc.id,
        doc.data(),
      );

      if (_isOverlapping(
        session,
        existing,
      )) {
        throw Exception(
          "Bạn đã có một Session khác trong khoảng thời gian này.",
        );
      }
    }

    // =======================================================
    // CHECK TRÙNG APPOINTMENT CỦA MENTOR
    // =======================================================

    final mentorAppointments =
        await _firestore
            .collection("appointments")
            .where(
              "mentorId",
              isEqualTo: session.mentorId,
            )
            .where(
              "status",
              whereIn: [
                "pending",
                "accepted",
              ],
            )
            .get();

    for (final doc
        in mentorAppointments.docs) {
      final data = doc.data();

      final start =
          _parseTimestamp(
        data["startAt"],
      );

      final end =
          _parseTimestamp(
        data["endAt"],
      );

      if (start == null || end == null) {
        continue;
      }

      final sessionStart =
          _getStartDateTime(session);

      final sessionEnd =
          _getEndDateTime(session);

      if (_isTimeOverlapping(
        sessionStart,
        sessionEnd,
        start,
        end,
      )) {
        throw Exception(
          "Bạn đã có Appointment trong khoảng thời gian này.",
        );
      }
    }

    // =======================================================
    // CREATE SESSION
    // =======================================================

    final docRef =
        await _firestore
            .collection("sessions")
            .add(
              session.toMap(),
            );

    // =======================================================
    // NOTIFICATION - SESSION CREATED
    // =======================================================

    await _notificationService.createNotification(
      userId: session.mentorId,
      title: "Tạo Session thành công",
      message:
          'Session "${session.title}" đã được tạo thành công vào ngày ${session.date}, từ ${session.startTime} đến ${session.endTime}.',
      type: "session_created",
      relatedId: docRef.id,
    );

    return docRef.id;
  }

  // =========================================================
  // UPDATE SESSION
  // =========================================================

  Future<void> updateSession(
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection("sessions")
        .doc(sessionId)
        .update(data);
  }

  // =========================================================
  // DELETE SESSION
  // =========================================================

  Future<void> deleteSession(
    String sessionId,
  ) async {
    final participants =
        await _firestore
            .collection(
              "session_participants",
            )
            .where(
              "sessionId",
              isEqualTo: sessionId,
            )
            .limit(1)
            .get();

    if (participants.docs.isNotEmpty) {
      throw Exception(
        "Không thể xóa Session đã có người tham gia.",
      );
    }

    await _firestore
        .collection("sessions")
        .doc(sessionId)
        .delete();
  }

  // =========================================================
  // GET MENTOR SESSIONS
  // =========================================================

  Stream<List<SessionModel>>
      getMentorSessions(
    String mentorId,
  ) {
    return _firestore
        .collection("sessions")
        .where(
          "mentorId",
          isEqualTo: mentorId,
        )
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final sessions =
            <SessionModel>[];

        for (final doc
            in snapshot.docs) {
          final session =
              SessionModel.fromMap(
            doc.id,
            doc.data(),
          );

          final updated =
              await _updateSessionStatus(
            session,
          );

          sessions.add(updated);
        }

        return sessions;
      },
    );
  }

  // =========================================================
  // GET AVAILABLE SESSIONS
  // =========================================================

  Stream<List<SessionModel>>
      getAvailableSessions() {
    return _firestore
        .collection("sessions")
        .where(
          "status",
          whereIn: [
            "open",
            "running",
          ],
        )
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final sessions =
            <SessionModel>[];

        for (final doc
            in snapshot.docs) {
          final session =
              SessionModel.fromMap(
            doc.id,
            doc.data(),
          );

          final updated =
              await _updateSessionStatus(
            session,
          );

          if (updated.status ==
                  "open" &&
              updated.bookedSlots <
                  updated.maxSlots) {
            sessions.add(updated);
          }
        }

        return sessions;
      },
    );
  }

  // =========================================================
  // GET AVAILABLE SESSIONS BY MENTOR
  // =========================================================

  Stream<List<SessionModel>>
      getAvailableSessionsByMentor(
    String mentorId,
  ) {
    return _firestore
        .collection("sessions")
        .where(
          "mentorId",
          isEqualTo: mentorId,
        )
        .where(
          "status",
          isEqualTo: "open",
        )
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final sessions =
            <SessionModel>[];

        for (final doc
            in snapshot.docs) {
          final session =
              SessionModel.fromMap(
            doc.id,
            doc.data(),
          );

          final updated =
              await _updateSessionStatus(
            session,
          );

          if (updated.status ==
                  "open" &&
              updated.bookedSlots <
                  updated.maxSlots) {
            sessions.add(updated);
          }
        }

        return sessions;
      },
    );
  }

  // =========================================================
  // GET MENTEE SESSIONS
  // =========================================================

  Stream<List<SessionModel>>
      getMenteeSessions(
    String menteeId,
  ) {
    return _firestore
        .collection(
          "session_participants",
        )
        .where(
          "menteeId",
          isEqualTo: menteeId,
        )
        .where(
          "status",
          isEqualTo: "joined",
        )
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final sessions =
            <SessionModel>[];

        for (final participant
            in snapshot.docs) {
          final data =
              participant.data();

          final sessionId =
              data["sessionId"];

          if (sessionId == null) {
            continue;
          }

          final sessionDoc =
              await _firestore
                  .collection(
                    "sessions",
                  )
                  .doc(sessionId)
                  .get();

          if (!sessionDoc.exists) {
            continue;
          }

          final session =
              SessionModel.fromMap(
            sessionDoc.id,
            sessionDoc.data()!,
          );

          final updated =
              await _updateSessionStatus(
            session,
          );

          sessions.add(updated);
        }

        return sessions;
      },
    );
  }

  // =========================================================
  // JOIN SESSION
  // =========================================================

  Future<void> joinSession({
    required SessionModel session,
    required String menteeId,
    required String menteeName,
  }) async {
    final sessionRef =
        _firestore
            .collection("sessions")
            .doc(session.id);

    final participantRef =
        _firestore
            .collection(
              "session_participants",
            )
            .doc(
              "${session.id}_$menteeId",
            );

    await _firestore.runTransaction(
      (transaction) async {
        final sessionSnapshot =
            await transaction.get(
          sessionRef,
        );

        if (!sessionSnapshot.exists) {
          throw Exception(
            "Session không tồn tại.",
          );
        }

        final data =
            sessionSnapshot.data()!;

        final currentSession =
            SessionModel.fromMap(
          sessionSnapshot.id,
          data,
        );

        // ===================================================
        // UPDATE STATUS
        // ===================================================

        final updatedStatus =
            _getExpectedStatus(
          currentSession,
        );

        if (updatedStatus !=
            currentSession.status) {
          transaction.update(
            sessionRef,
            {
              "status":
                  updatedStatus,
            },
          );
        }

        // ===================================================
        // CHECK STATUS
        // ===================================================

        if (updatedStatus !=
            "open") {
          throw Exception(
            "Session không còn mở để tham gia.",
          );
        }

        final int bookedSlots =
            (data["bookedSlots"] ??
                    0) as int;

        final int maxSlots =
            (data["maxSlots"] ??
                    0) as int;

        // ===================================================
        // CHECK FULL
        // ===================================================

        if (bookedSlots >=
            maxSlots) {
          throw Exception(
            "Session đã đầy.",
          );
        }

        // ===================================================
        // CHECK ĐÃ JOIN
        // ===================================================

        final participantSnapshot =
            await transaction.get(
          participantRef,
        );

        if (participantSnapshot
            .exists) {
          throw Exception(
            "Bạn đã tham gia Session này.",
          );
        }

        // ===================================================
        // CHECK MENTEE CÓ APPOINTMENT TRÙNG KHÔNG
        // ===================================================

        final appointmentSnapshot =
            await _firestore
                .collection(
                  "appointments",
                )
                .where(
                  "menteeId",
                  isEqualTo: menteeId,
                )
                .where(
                  "status",
                  whereIn: [
                    "pending",
                    "accepted",
                  ],
                )
                .get();

        final sessionStart =
            _getStartDateTime(
          currentSession,
        );

        final sessionEnd =
            _getEndDateTime(
          currentSession,
        );

        for (final doc
            in appointmentSnapshot
                .docs) {
          final appointmentData =
              doc.data();

          final appointmentStart =
              _parseTimestamp(
            appointmentData[
                "startAt"],
          );

          final appointmentEnd =
              _parseTimestamp(
            appointmentData[
                "endAt"],
          );

          if (appointmentStart ==
                  null ||
              appointmentEnd ==
                  null) {
            continue;
          }

          if (_isTimeOverlapping(
            sessionStart,
            sessionEnd,
            appointmentStart,
            appointmentEnd,
          )) {
            throw Exception(
              "Bạn đã có Appointment trong khoảng thời gian này.",
            );
          }
        }

        // ===================================================
        // JOIN
        // ===================================================

        transaction.update(
          sessionRef,
          {
            "bookedSlots":
                bookedSlots + 1,
          },
        );

        transaction.set(
          participantRef,
          SessionParticipantModel(
            id:
                participantRef.id,
            sessionId:
                session.id,
            mentorId:
                session.mentorId,
            menteeId:
                menteeId,
            menteeName:
                menteeName,
            status:
                "joined",
            joinedAt:
                DateTime.now(),
          ).toMap(),
        );
      },
    );

    // =======================================================
    // NOTIFICATION - MENTEE JOIN
    // =======================================================

    await _notificationService
        .createNotification(
      userId: session.mentorId,
      title:
          "Có Mentee tham gia Session",
      message:
          '$menteeName đã tham gia Session "${session.title}".',
      type:
          "session_joined",
      relatedId:
          session.id,
    );
  }

  // =========================================================
  // LEAVE SESSION
  // =========================================================

  Future<void> leaveSession({
    required String sessionId,
    required String participantId,
  }) async {
    final sessionRef =
        _firestore
            .collection("sessions")
            .doc(sessionId);

    final participantRef =
        _firestore
            .collection(
              "session_participants",
            )
            .doc(participantId);

    // =======================================================
    // GET SESSION
    // =======================================================

    final sessionDoc =
        await sessionRef.get();

    if (!sessionDoc.exists) {
      throw Exception(
        "Session không tồn tại.",
      );
    }

    final session =
        SessionModel.fromMap(
      sessionDoc.id,
      sessionDoc.data()!,
    );

    // =======================================================
    // GET PARTICIPANT
    // =======================================================

    final participantDoc =
        await participantRef.get();

    if (!participantDoc.exists) {
      throw Exception(
        "Participant không tồn tại.",
      );
    }

    final participantData =
        participantDoc.data()!;

    final menteeName =
        participantData[
                "menteeName"]
            ?.toString() ??
        "Một Mentee";

    // =======================================================
    // LEAVE TRANSACTION
    // =======================================================

    await _firestore.runTransaction(
      (transaction) async {
        final sessionSnapshot =
            await transaction.get(
          sessionRef,
        );

        if (!sessionSnapshot.exists) {
          throw Exception(
            "Session không tồn tại.",
          );
        }

        final participantSnapshot =
            await transaction.get(
          participantRef,
        );

        if (!participantSnapshot
            .exists) {
          throw Exception(
            "Participant không tồn tại.",
          );
        }

        final data =
            sessionSnapshot.data()!;

        final currentSession =
            SessionModel.fromMap(
          sessionSnapshot.id,
          data,
        );

        final currentStatus =
            _getExpectedStatus(
          currentSession,
        );

        if (currentStatus !=
            "open") {
          throw Exception(
            "Không thể rời Session đã bắt đầu hoặc đã kết thúc.",
          );
        }

        final int bookedSlots =
            (data["bookedSlots"] ??
                    0) as int;

        transaction.update(
          sessionRef,
          {
            "bookedSlots":
                bookedSlots > 0
                    ? bookedSlots - 1
                    : 0,
          },
        );

        transaction.delete(
          participantRef,
        );
      },
    );

    // =======================================================
    // NOTIFICATION - MENTEE LEAVE
    // =======================================================

    await _notificationService
        .createNotification(
      userId: session.mentorId,
      title:
          "Mentee đã rời Session",
      message:
          '$menteeName đã rời khỏi Session "${session.title}".',
      type:
          "session_left",
      relatedId:
          session.id,
    );
  }

  // =========================================================
  // KICK PARTICIPANT
  // =========================================================

  Future<void> kickParticipant({
    required String sessionId,
    required String participantId,
  }) async {
    final sessionRef =
        _firestore
            .collection("sessions")
            .doc(sessionId);

    final participantRef =
        _firestore
            .collection(
              "session_participants",
            )
            .doc(participantId);

    // =======================================================
    // GET SESSION
    // =======================================================

    final sessionDoc =
        await sessionRef.get();

    if (!sessionDoc.exists) {
      throw Exception(
        "Session không tồn tại.",
      );
    }

    final session =
        SessionModel.fromMap(
      sessionDoc.id,
      sessionDoc.data()!,
    );

    // =======================================================
    // GET PARTICIPANT
    // =======================================================

    final participantDoc =
        await participantRef.get();

    if (!participantDoc.exists) {
      throw Exception(
        "Participant không tồn tại.",
      );
    }

    final participantData =
        participantDoc.data()!;

    final menteeId =
        participantData[
                "menteeId"]
            ?.toString() ??
        "";

    // =======================================================
    // KICK TRANSACTION
    // =======================================================

    await _firestore.runTransaction(
      (transaction) async {
        final sessionSnapshot =
            await transaction.get(
          sessionRef,
        );

        if (!sessionSnapshot.exists) {
          throw Exception(
            "Session không tồn tại.",
          );
        }

        final participantSnapshot =
            await transaction.get(
          participantRef,
        );

        if (!participantSnapshot
            .exists) {
          throw Exception(
            "Participant không tồn tại.",
          );
        }

        final data =
            sessionSnapshot.data()!;

        final currentSession =
            SessionModel.fromMap(
          sessionSnapshot.id,
          data,
        );

        final currentStatus =
            _getExpectedStatus(
          currentSession,
        );

        // Chỉ được kick khi Session chưa bắt đầu
        if (currentStatus !=
            "open") {
          throw Exception(
            "Không thể kick mentee khi Session đã bắt đầu hoặc đã kết thúc.",
          );
        }

        final int bookedSlots =
            (data["bookedSlots"] ??
                    0) as int;

        // ===================================================
        // DECREASE BOOKED SLOTS
        // ===================================================

        transaction.update(
          sessionRef,
          {
            "bookedSlots":
                bookedSlots > 0
                    ? bookedSlots - 1
                    : 0,
          },
        );

        // ===================================================
        // REMOVE PARTICIPANT
        // ===================================================

        transaction.delete(
          participantRef,
        );
      },
    );

    // =======================================================
    // NOTIFICATION - MENTEE KICKED
    // =======================================================

    if (menteeId.isNotEmpty) {
      await _notificationService
          .createNotification(
        userId: menteeId,
        title:
            "Bạn đã bị xóa khỏi Session",
        message:
            'Bạn đã bị Mentor xóa khỏi Session "${session.title}".',
        type:
            "session_kicked",
        relatedId:
            session.id,
      );
    }
  }

  // =========================================================
  // GET PARTICIPANTS
  // =========================================================

  Stream<
      List<SessionParticipantModel>>
      getParticipants(
    String sessionId,
  ) {
    return _firestore
        .collection(
          "session_participants",
        )
        .where(
          "sessionId",
          isEqualTo: sessionId,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  SessionParticipantModel
                      .fromMap(
                doc.id,
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  // =========================================================
  // GET JOINED SESSIONS
  // =========================================================

  Stream<
      List<SessionParticipantModel>>
      getJoinedSessions(
    String menteeId,
  ) {
    return _firestore
        .collection(
          "session_participants",
        )
        .where(
          "menteeId",
          isEqualTo: menteeId,
        )
        .where(
          "status",
          isEqualTo: "joined",
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  SessionParticipantModel
                      .fromMap(
                doc.id,
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  // =========================================================
  // CANCEL SESSION
  // =========================================================

  Future<void> cancelSession(
    String sessionId,
  ) async {
    final sessionDoc =
        await _firestore
            .collection("sessions")
            .doc(sessionId)
            .get();

    if (!sessionDoc.exists) {
      throw Exception(
        "Session không tồn tại.",
      );
    }

    final session =
        SessionModel.fromMap(
      sessionDoc.id,
      sessionDoc.data()!,
    );

    final currentStatus =
        _getExpectedStatus(
      session,
    );

    if (currentStatus ==
            "running" ||
        currentStatus ==
            "completed") {
      throw Exception(
        "Không thể hủy Session đã bắt đầu hoặc đã kết thúc.",
      );
    }

    if (currentStatus ==
        "cancelled") {
      throw Exception(
        "Session đã bị hủy.",
      );
    }

    // =======================================================
    // GET PARTICIPANTS
    // =======================================================

    final participantsSnapshot =
        await _firestore
            .collection(
              "session_participants",
            )
            .where(
              "sessionId",
              isEqualTo: sessionId,
            )
            .where(
              "status",
              isEqualTo: "joined",
            )
            .get();

    // =======================================================
    // CANCEL SESSION
    // =======================================================

    await _firestore
        .collection("sessions")
        .doc(sessionId)
        .update({
      "status": "cancelled",
    });

    // =======================================================
    // NOTIFICATION - SESSION CANCELLED
    // =======================================================

    for (final doc
        in participantsSnapshot.docs) {
      final data =
          doc.data();

      final menteeId =
          data["menteeId"]
              ?.toString() ??
          "";

      if (menteeId.isEmpty) {
        continue;
      }

      await _notificationService
          .createNotification(
        userId: menteeId,
        title:
            "Session đã bị hủy",
        message:
            'Session "${session.title}" vào ngày ${session.date} từ ${session.startTime} đến ${session.endTime} đã bị Mentor hủy.',
        type:
            "session_cancelled",
        relatedId:
            session.id,
      );
    }
  }

  // =========================================================
  // HAS JOINED
  // =========================================================

  Future<bool> hasJoined({
    required String sessionId,
    required String menteeId,
  }) async {
    final participantId =
        "${sessionId}_$menteeId";

    final result =
        await _firestore
            .collection(
              "session_participants",
            )
            .doc(participantId)
            .get();

    return result.exists;
  }

  // =========================================================
  // GET SESSION
  // =========================================================

  Future<SessionModel?> getSession(
    String sessionId,
  ) async {
    final doc =
        await _firestore
            .collection("sessions")
            .doc(sessionId)
            .get();

    if (!doc.exists) {
      return null;
    }

    final session =
        SessionModel.fromMap(
      doc.id,
      doc.data()!,
    );

    return _updateSessionStatus(
      session,
    );
  }

  // =========================================================
  // AUTO SESSION STATUS
  // =========================================================

  String _getExpectedStatus(
    SessionModel session,
  ) {
    final now =
        DateTime.now();

    final start =
        _getStartDateTime(
      session,
    );

    final end =
        _getEndDateTime(
      session,
    );

    // Không thay đổi trạng thái
    // đã bị hủy hoặc đã hoàn thành
    if (session.status ==
            "cancelled" ||
        session.status ==
            "completed") {
      return session.status;
    }

    // Chưa tới giờ
    if (now.isBefore(start)) {
      return "open";
    }

    // Đang trong thời gian Session
    if (now.isBefore(end)) {
      return session.bookedSlots >
              0
          ? "running"
          : "cancelled";
    }

    // Đã qua endTime
    return "completed";
  }

  // =========================================================
  // UPDATE SESSION STATUS
  // =========================================================

  Future<SessionModel>
      _updateSessionStatus(
    SessionModel session,
  ) async {
    final expectedStatus =
        _getExpectedStatus(
      session,
    );

    if (expectedStatus !=
        session.status) {
      await _firestore
          .collection("sessions")
          .doc(session.id)
          .update({
        "status":
            expectedStatus,
      });

      return session.copyWith(
        status:
            expectedStatus,
      );
    }

    return session;
  }

  // =========================================================
  // OVERLAPPING SESSION
  // =========================================================

  bool _isOverlapping(
    SessionModel newSession,
    SessionModel existingSession,
  ) {
    final newStart =
        _getStartDateTime(
      newSession,
    );

    final newEnd =
        _getEndDateTime(
      newSession,
    );

    final existingStart =
        _getStartDateTime(
      existingSession,
    );

    final existingEnd =
        _getEndDateTime(
      existingSession,
    );

    return _isTimeOverlapping(
      newStart,
      newEnd,
      existingStart,
      existingEnd,
    );
  }

  // =========================================================
  // OVERLAPPING TIME
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
  // GET START DATETIME
  // =========================================================

  DateTime _getStartDateTime(
    SessionModel session,
  ) {
    final dateParts =
        session.date.split("-");

    final timeParts =
        session.startTime.split(":");

    return DateTime(
      int.parse(
        dateParts[0],
      ),
      int.parse(
        dateParts[1],
      ),
      int.parse(
        dateParts[2],
      ),
      int.parse(
        timeParts[0],
      ),
      int.parse(
        timeParts[1],
      ),
    );
  }

  // =========================================================
  // GET END DATETIME
  // =========================================================

  DateTime _getEndDateTime(
    SessionModel session,
  ) {
    final dateParts =
        session.date.split("-");

    final timeParts =
        session.endTime.split(":");

    return DateTime(
      int.parse(
        dateParts[0],
      ),
      int.parse(
        dateParts[1],
      ),
      int.parse(
        dateParts[2],
      ),
      int.parse(
        timeParts[0],
      ),
      int.parse(
        timeParts[1],
      ),
    );
  }

  // =========================================================
  // PARSE FIRESTORE TIMESTAMP
  // =========================================================

  DateTime? _parseTimestamp(
    dynamic value,
  ) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(
        value,
      );
    }

    return null;
  }
}