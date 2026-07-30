import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMint,
      appBar: AppBar(
        title: const Text("Mentor Dashboard"),
        backgroundColor: AppColors.mintGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Thông tin Mentor
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.softMint,
                  child: Icon(Icons.person,
                      color: AppColors.deepGreen, size: 30),
                ),
                title: const Text(
                  "Nguyễn Văn A",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Flutter Mentor"),
                trailing: const Icon(Icons.notifications_none),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Thống kê",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: statCard(Icons.people, "25", "Mentee")),
                const SizedBox(width: 10),
                Expanded(child: statCard(Icons.star, "4.9", "Rating")),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: statCard(Icons.calendar_today, "12", "Lịch")),
                const SizedBox(width: 10),
                Expanded(child: statCard(Icons.check_circle, "18", "Hoàn thành")),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Yêu cầu kết nối",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            requestCard("Trần Văn B", "Muốn học Flutter cơ bản"),
            requestCard("Lê Thị C", "Xin mentor Java Backend"),

            const SizedBox(height: 20),

            const Text(
              "Lịch hôm nay",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule,
                    color: AppColors.mintGreen),
                title: const Text("Review CV"),
                subtitle: const Text("09:00 - 10:00"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget statCard(IconData icon, String value, String title) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Icon(icon, color: AppColors.mintGreen, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  static Widget requestCard(String name, String content) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.softMint,
          child: Icon(Icons.person, color: AppColors.deepGreen),
        ),
        title: Text(name),
        subtitle: Text(content),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mintGreen,
          ),
          onPressed: () {},
          child: const Text(
            "Xem",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}