import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/services/appointment_service.dart';

class MyAppointmentsTab extends StatelessWidget {
  MyAppointmentsTab({super.key});

  final AppointmentService _service = AppointmentService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("Chưa đăng nhập"));
    }

    return StreamBuilder<List<AppointmentModel>>(
      stream: _service.getMenteeAppointments(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Chưa có lịch hẹn"));
        }

        final list = snapshot.data!;

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];

            Color statusColor;
            if (item.status == "accepted") {
              statusColor = Colors.green;
            } else if (item.status == "rejected") {
              statusColor = Colors.red;
            } else {
              statusColor = Colors.orange;
            }

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: const Icon(Icons.calendar_today),

                title: Text("Mentor: ${item.mentorName}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ngày: ${item.date}"),
                    Text("Giờ: ${item.time}"),
                    Text("Ghi chú: ${item.note}"),
                    Text(
                      "Trạng thái: ${item.status}",
                      style: TextStyle(color: statusColor),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}