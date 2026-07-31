import '../../../models/appointment_model.dart';
import '../../../models/session_model.dart';

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

  /// Dữ liệu gốc
  final dynamic data;

  const ScheduleItem({
    required this.startAt,
    required this.endAt,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.data,
  });

  bool get isSession => type == ScheduleType.session;

  bool get isAppointment => type == ScheduleType.appointment;

  String get title =>
      isSession ? "Session" : "Appointment";

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
      data: session,
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
      data: appointment,
    );
  }

  SessionModel? get session =>
      isSession ? data as SessionModel : null;

  AppointmentModel? get appointment =>
      isAppointment ? data as AppointmentModel : null;
}