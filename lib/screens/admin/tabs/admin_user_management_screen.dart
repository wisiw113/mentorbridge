import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState
    extends State<AdminUserManagementScreen> {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");

  Future<void> updateStatus(String uid, String status) async {
    await usersRef.doc(uid).update({
      "status": status,
    });
  }

  Future<void> deleteUser(String uid) async {
    await usersRef.doc(uid).delete();
  }

  Future<void> signOut() async {
    final logout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (logout == true) {
      await FirebaseAuth.instance.signOut();
      // Nếu dùng AuthGate thì không cần Navigator
    }
  }

  void showEditDialog(String uid, Map<String, dynamic> data) {
    String status = data["status"] ?? "pending";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Edit User"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: status,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: "pending",
                        child: Text("Pending"),
                      ),
                      DropdownMenuItem(
                        value: "approved",
                        child: Text("Approved"),
                      ),
                      DropdownMenuItem(
                        value: "rejected",
                        child: Text("Rejected"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setStateDialog(() {
                          status = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await usersRef.doc(uid).update({
                      "status": status,
                    });

                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin User Management"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No users found"),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;

              final uid = doc.id;
              final email = data["email"] ?? "";
              final role = data["role"] ?? "-";
              final status = data["status"] ?? "-";

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(email),
                  subtitle: Text(
                    "Role: $role\nStatus: $status",
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: "Edit",
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () => showEditDialog(uid, data),
                      ),
                      IconButton(
                        tooltip: "Approve",
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onPressed: () => updateStatus(
                          uid,
                          "approved",
                        ),
                      ),
                      IconButton(
                        tooltip: "Reject",
                        icon: const Icon(
                          Icons.close,
                          color: Colors.orange,
                        ),
                        onPressed: () => updateStatus(
                          uid,
                          "rejected",
                        ),
                      ),
                      IconButton(
                        tooltip: "Delete",
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => deleteUser(uid),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}