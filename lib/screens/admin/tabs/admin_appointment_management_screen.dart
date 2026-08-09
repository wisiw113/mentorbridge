import 'package:flutter/material.dart';

import '../../../models/appointment_model.dart';
import '../../../services/appointment_service.dart';

import '../../../widgets/admin/admin_appointment_management/admin_appointment_card.dart';
import '../../../widgets/admin/admin_appointment_management/admin_appointment_detail_dialog.dart';
import '../../../widgets/admin/admin_appointment_management/admin_appointment_empty_state.dart';
import '../../../widgets/admin/admin_appointment_management/admin_appointment_filter.dart';
import '../../../widgets/admin/admin_appointment_management/admin_appointment_header.dart';

class AdminAppointmentManagementScreen extends StatefulWidget {
  const AdminAppointmentManagementScreen({super.key});

  @override
  State<AdminAppointmentManagementScreen> createState() =>
      _AdminAppointmentManagementScreenState();
}

class _AdminAppointmentManagementScreenState
    extends State<AdminAppointmentManagementScreen> {
  final AppointmentService _appointmentService =
      AppointmentService();

  String selectedFilter = "All";

  List<AppointmentModel> _filterAppointments(
    List<AppointmentModel> appointments,
  ) {
    if (selectedFilter == "All") {
      return appointments;
    }

    return appointments.where((appointment) {
      return appointment.status.toLowerCase() ==
          selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<AppointmentModel>>(
        stream:
            _appointmentService.getAllAppointments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong.",
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final appointments =
              snapshot.data ?? [];

          final filteredAppointments =
              _filterAppointments(
            appointments,
          );

          return Column(
            children: [
              //------------------------------------------------
              // HEADER
              //------------------------------------------------

              AdminAppointmentHeader(
                totalAppointments:
                    appointments.length,
              ),

              //------------------------------------------------
              // FILTER
              //------------------------------------------------

              AdminAppointmentFilter(
                selectedFilter:
                    selectedFilter,
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              //------------------------------------------------
              // LIST
              //------------------------------------------------

              Expanded(
                child:
                    filteredAppointments.isEmpty
                        ? const AdminAppointmentEmptyState()
                        : ListView.builder(
                            padding:
                                const EdgeInsets
                                    .fromLTRB(
                              16,
                              0,
                              16,
                              20,
                            ),
                            itemCount:
                                filteredAppointments
                                    .length,
                            itemBuilder:
                                (context, index) {
                              final appointment =
                                  filteredAppointments[
                                      index];

                              return AdminAppointmentCard(
                                mentorName:
                                    appointment
                                        .mentorName,
                                menteeName:
                                    appointment
                                        .menteeName,
                                topic:
                                    appointment.topic,
                                date:
                                    appointment.date,
                                startTime: appointment
                                    .startTime,
                                endTime:
                                    appointment
                                        .endTime,
                                status:
                                    appointment
                                        .status,
                                rated:
                                    appointment
                                        .rated,
                                onViewDetails: () {
                                  showDialog(
                                    context:
                                        context,
                                    builder:
                                        (_) =>
                                            AdminAppointmentDetailDialog(
                                      appointmentId:
                                          appointment
                                              .id,
                                      mentorName:
                                          appointment
                                              .mentorName,
                                      menteeName:
                                          appointment
                                              .menteeName,
                                      topic:
                                          appointment
                                              .topic,
                                      note:
                                          appointment
                                              .note,
                                      date:
                                          appointment
                                              .date,
                                      startTime:
                                          appointment
                                              .startTime,
                                      endTime:
                                          appointment
                                              .endTime,
                                      status:
                                          appointment
                                              .status,
                                      rated:
                                          appointment
                                              .rated,
                                      rejectReason:
                                          appointment
                                              .rejectReason,
                                      cancelReason:
                                          appointment
                                              .cancelReason,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}