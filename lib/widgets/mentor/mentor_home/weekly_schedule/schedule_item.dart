import '/../../models/appointment_model.dart';
import '/../../models/session_model.dart';

enum ScheduleType {
  session,
  appointment,
}

class ScheduleItem {
  final DateTime startAt;
  final DateTime endAt;

  final String startTime;
  final String endTime;

  final ScheduleType type;

  /// Model gốc
  final dynamic source;

  const ScheduleItem({
    required this.startAt,
    required this.endAt,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.source,
  });

  /// Kiểm tra loại
  bool get isSession => type == ScheduleType.session;

  bool get isAppointment => type == ScheduleType.appointment;

  /// Hiển thị trên UI
  /// S = Session
  /// A = Appointment
  String get title => isSession ? "S" : "A";

  /// Tạo từ Session
  factory ScheduleItem.fromSession(
    SessionModel session,
  ) {
    return ScheduleItem(
      startAt: session.startAt,
      endAt: session.endAt,
      startTime: session.startTime,
      endTime: session.endTime,
      type: ScheduleType.session,
      source: session,
    );
  }

  /// Tạo từ Appointment
  factory ScheduleItem.fromAppointment(
    AppointmentModel appointment,
  ) {
    return ScheduleItem(
      startAt: appointment.startAt,
      endAt: appointment.endAt,
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      type: ScheduleType.appointment,
      source: appointment,
    );
  }

  /// Lấy SessionModel nếu là Session
  SessionModel? get session {
    if (isSession) {
      return source as SessionModel;
    }

    return null;
  }

  /// Lấy AppointmentModel nếu là Appointment
  AppointmentModel? get appointment {
    if (isAppointment) {
      return source as AppointmentModel;
    }

    return null;
  }
}