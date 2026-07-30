import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../widgets/common/confirm_dialog.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  String name = "";
  String role = "";
  String email = "";
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // 🔥 LOAD USER
  Future<void> loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data();

    setState(() {
      name = data?['name'] ?? "";
      role = data?['role'] ?? "mentee";
      email = FirebaseAuth.instance.currentUser?.email ?? "";
      avatarUrl = data?['avatarUrl'];
    });
  }

  // 🔥 UPDATE NAME (quick update)
  Future<void> updateName(String newName) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': newName,
    });

    setState(() => name = newName);
  }

  // 🔥 PICK & UPLOAD AVATAR
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    File file = File(picked.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('avatars/$uid.jpg');

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'avatarUrl': url});

    setState(() {
      avatarUrl = url;
    });
  }

  // ✨ POPUP EDIT PROFILE (FULL)
  void editProfileDialog() {
    final nameController = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chỉnh sửa thông tin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Tên",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .set({
                'name': nameController.text,
              }, SetOptions(merge: true));

              setState(() {
                name = nameController.text;
              });

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  // 🔥 LOGOUT
 Future<void> logout() async {
  final confirm = await showConfirmDialog(
    context,
    title: "Logout",
    content: "Are you sure you want to logout?",
  );

  // Nếu bấm No thì không làm gì
  if (!confirm) return;

  // Nếu bấm Yes thì đăng xuất
  await FirebaseAuth.instance.signOut();

  if (context.mounted) {
    Navigator.pushReplacementNamed(context, "/login");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // AVATAR
            GestureDetector(
              onTap: pickAndUploadImage,
              child: CircleAvatar(
                radius: 45,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            // NAME
            GestureDetector(
              onTap: editProfileDialog,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ROLE
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(role.toUpperCase()),
            ),

            const SizedBox(height: 12),

            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // ✨ BUTTON EDIT PROFILE
            ElevatedButton(
              onPressed: editProfileDialog,
              child: const Text("Chỉnh sửa thông tin"),
            ),

            const SizedBox(height: 10),

            // LOGOUT
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Đăng xuất"),
            ),
          ],
        ),
      ),
    );
  }
}