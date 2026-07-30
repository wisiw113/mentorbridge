import 'package:flutter/material.dart';

import 'admin_pending_user_card.dart';

class AdminPendingUsersSection extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  final Function(String uid) onApprove;
  final Function(String uid) onReject;

  const AdminPendingUsersSection({
    super.key,
    required this.users,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // Chỉ hiển thị tối đa 5 user
    final pendingUsers = users.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= HEADER =================

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Pending Approval",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (users.length > 5)
              TextButton(
                onPressed: () {
                  // Sau này có thể mở
                  // Admin User Management
                },
                child: const Text(
                  "View All",
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        // ================= EMPTY =================

        if (pendingUsers.isEmpty)
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 45,
                      color: Colors.green.shade600,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "No pending users",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Tất cả tài khoản đã được xử lý.",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

        // ================= USER LIST =================

        else
          ...pendingUsers.map(
            (user) {
              final uid =
                  user["uid"]?.toString() ?? "";

              return AdminPendingUserCard(
                name:
                    user["name"]?.toString() ?? "",
                major:
                    user["major"]?.toString() ?? "",
                role:
                    user["role"]?.toString() ?? "",

                onApprove: () {
                  onApprove(uid);
                },

                onReject: () {
                  onReject(uid);
                },
              );
            },
          ),
      ],
    );
  }
}