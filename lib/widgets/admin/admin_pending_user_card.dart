import 'package:flutter/material.dart';

class AdminPendingUserCard extends StatelessWidget {
  final String name;
  final String major;
  final String role;

  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AdminPendingUserCard({
    super.key,
    required this.name,
    required this.major,
    required this.role,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= USER INFO =================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundColor:
                      Colors.green.shade50,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.green.shade700,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                // Information
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty
                            ? "Unknown User"
                            : name,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        major.isEmpty
                            ? "Chưa cập nhật ngành học"
                            : major,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        role.isEmpty
                            ? "Chưa xác định"
                            : role,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ================= ACTION BUTTONS =================

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          Colors.red.shade600,
                      side: BorderSide(
                        color:
                            Colors.red.shade300,
                      ),
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 12,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green.shade700,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 12,
                      ),
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Approve",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}