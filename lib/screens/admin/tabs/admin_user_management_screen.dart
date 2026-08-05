
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../../../widgets/admin/user_management/admin_user_header.dart';
import '../../../widgets/admin/user_management/admin_user_filter.dart';
import '../../../widgets/admin/user_management/admin_user_card.dart';
import '../../../widgets/admin/user_management/admin_user_empty_state.dart';

import '../../../widgets/common/confirm_dialog.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState
    extends State<AdminUserManagementScreen> {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  String _selectedStatus = 'all';

  // =====================================================
  // UPDATE STATUS
  // =====================================================

  Future<void> updateStatus(
    String uid,
    String status,
  ) async {
    await usersRef.doc(uid).update({
      'status': status,
    });
  }

  // =====================================================
  // APPROVE USER
  // =====================================================

  Future<void> approveUser(String uid) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Approve User',
      content: 'Are you sure you want to approve this user?',
    );

    if (!confirmed) return;

    await updateStatus(uid, 'approved');
  }

  // =====================================================
  // REJECT USER
  // =====================================================

  Future<void> rejectUser(String uid) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reject User',
      content: 'Are you sure you want to reject this user?',
    );

    if (!confirmed) return;

    await updateStatus(uid, 'rejected');
  }

  // =====================================================
  // DELETE USER
  // =====================================================

  Future<void> deleteUser(String uid) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete User',
      content: 'Are you sure you want to delete this user?',
    );

    if (!confirmed) return;

    await usersRef.doc(uid).delete();
  }

  // =====================================================
  // EDIT USER
  // =====================================================

  void showEditDialog(
    String uid,
    Map<String, dynamic> data,
  ) {
    String status = data['status'] ?? 'pending';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =================================================
                    // TITLE
                    // =================================================

                    const Text(
                      'Edit User',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      data['email']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // STATUS LABEL
                    // =================================================

                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =================================================
                    // STATUS DROPDOWN
                    // =================================================

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softMint.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.mintGreen.withOpacity(0.2),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: status,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.deepGreen,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'pending',
                              child: Text('Pending'),
                            ),
                            DropdownMenuItem(
                              value: 'approved',
                              child: Text('Approved'),
                            ),
                            DropdownMenuItem(
                              value: 'rejected',
                              child: Text('Rejected'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setStateDialog(() {
                              status = value;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =================================================
                    // BUTTONS
                    // =================================================

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.border.withOpacity(0.15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColors.darkGray,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await usersRef.doc(uid).update({
                                'status': status,
                              });

                              if (!mounted) return;

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mintGreen,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
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
          },
        );
      },
    );
  }

  // =====================================================
  // FILTER USERS
  // =====================================================

  List<QueryDocumentSnapshot> filterUsers(
    List<QueryDocumentSnapshot> users,
  ) {
    if (_selectedStatus == 'all') {
      return users;
    }

    return users.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final status = data['status'] ?? 'pending';

      return status == _selectedStatus;
    }).toList();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMint.withOpacity(0.12),

      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          // =================================================
          // ERROR
          // =================================================

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          // =================================================
          // LOADING
          // =================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mintGreen,
              ),
            );
          }

          // =================================================
          // NO USERS
          // =================================================

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const AdminUserEmptyState();
          }

          final users = snapshot.data!.docs;

          final filteredUsers = filterUsers(users);

          // =================================================
          // CONTENT
          // =================================================

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // =================================================
              // HEADER
              // =================================================

              AdminUserHeader(
                totalUsers: users.length,
              ),

              const SizedBox(height: 16),

              // =================================================
              // FILTER
              // =================================================

              AdminUserFilter(
                selectedStatus: _selectedStatus,
                onStatusChanged: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),

              const SizedBox(height: 16),

              // =================================================
              // FILTER EMPTY
              // =================================================

              if (filteredUsers.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: AdminUserEmptyState(),
                ),

              // =================================================
              // USER LIST
              // =================================================

              ...filteredUsers.map((doc) {
                final data =
                    doc.data() as Map<String, dynamic>;

                final uid = doc.id;

                final email =
                    data['email']?.toString() ?? '';

                final role =
                    data['role']?.toString() ?? '-';

                final status =
                    data['status']?.toString() ?? 'pending';

                return AdminUserCard(
                  email: email,
                  role: role,
                  status: status,

                  onEdit: () {
                    showEditDialog(
                      uid,
                      data,
                    );
                  },

                  onApprove: () {
                    approveUser(uid);
                  },

                  onReject: () {
                    rejectUser(uid);
                  },

                  onDelete: () {
                    deleteUser(uid);
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

