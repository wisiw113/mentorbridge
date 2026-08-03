
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/cloudinary_service.dart';
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

  bool loadingAvatar = false;
  bool loadingUser = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // =========================================================
  // LOAD USER
  // =========================================================

  Future<void> loadUser() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final data = doc.data();

      if (!mounted) return;

      setState(() {
        name = data?['name'] ?? "";
        role = data?['role'] ?? "mentee";
        email =
            FirebaseAuth.instance.currentUser?.email ?? "";
        avatarUrl = data?['avatarUrl'];
        loadingUser = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingUser = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể tải thông tin người dùng: $e',
          ),
        ),
      );
    }
  }

  // =========================================================
  // UPDATE NAME
  // =========================================================

  Future<void> updateName(String newName) async {
    final trimmedName = newName.trim();

    if (trimmedName.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(
      {
        'name': trimmedName,
      },
      SetOptions(merge: true),
    );

    if (!mounted) return;

    setState(() {
      name = trimmedName;
    });
  }

  // =========================================================
  // PICK & UPLOAD AVATAR
  // CLOUDINARY
  // =========================================================

  Future<void> pickAndUploadImage() async {
    if (loadingAvatar) {
      return;
    }

    try {
      final picker = ImagePicker();

      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) {
        return;
      }

      setState(() {
        loadingAvatar = true;
      });

      final file = File(picked.path);

      // Upload ảnh lên Cloudinary
      //
      // CloudinaryService của bạn đang có:
      // uploadAvatar(File file)
      //
      // Không dùng uploadImage()
      final url =
          await CloudinaryService.uploadAvatar(file);

      if (url == null || url.isEmpty) {
        throw Exception(
          'Không thể tải ảnh lên Cloudinary.',
        );
      }

      // Lưu URL Cloudinary vào Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(
        {
          'avatarUrl': url,
        },
        SetOptions(merge: true),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        avatarUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cập nhật ảnh đại diện thành công.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      final message = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể cập nhật ảnh: $message',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loadingAvatar = false;
        });
      }
    }
  }

  // =========================================================
  // EDIT PROFILE
  // =========================================================

  void editProfileDialog() {
    final nameController =
        TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Chỉnh sửa thông tin",
          ),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Tên",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName =
                    nameController.text.trim();

                if (newName.isEmpty) {
                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Tên không được để trống.',
                      ),
                    ),
                  );

                  return;
                }

                try {
                  await updateName(newName);

                  if (!dialogContext.mounted) {
                    return;
                  }

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cập nhật thông tin thành công.',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!dialogContext.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Không thể cập nhật: $e',
                      ),
                    ),
                  );
                }
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
    });
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    final confirm = await showConfirmDialog(
      context,
      title: "Logout",
      content: "Are you sure you want to logout?",
    );

    // Người dùng chọn No
    if (!confirm) {
      return;
    }

    // Người dùng chọn Yes
    await FirebaseAuth.instance.signOut();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      "/login",
    );
  }

  // =========================================================
  // AVATAR WIDGET
  // =========================================================

  Widget buildAvatar() {
    final hasAvatar =
        avatarUrl != null &&
        avatarUrl!.isNotEmpty;

    return GestureDetector(
      onTap: loadingAvatar
          ? null
          : pickAndUploadImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: hasAvatar
                ? NetworkImage(avatarUrl!)
                : null,
            child: !hasAvatar
                ? Text(
                    name.isNotEmpty
                        ? name[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),

          if (loadingAvatar)
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.35,
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    if (loadingUser) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              // =================================================
              // AVATAR
              // =================================================

              buildAvatar(),

              const SizedBox(height: 8),

              const Text(
                "Nhấn vào ảnh để thay đổi",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // =================================================
              // NAME
              // =================================================

              GestureDetector(
                onTap: editProfileDialog,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // =================================================
              // ROLE
              // =================================================

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  role.toUpperCase(),
                ),
              ),

              const SizedBox(height: 12),

              // =================================================
              // EMAIL
              // =================================================

              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              // =================================================
              // EDIT PROFILE
              // =================================================

              ElevatedButton(
                onPressed: editProfileDialog,
                child: const Text(
                  "Chỉnh sửa thông tin",
                ),
              ),

              const SizedBox(height: 10),

              // =================================================
              // LOGOUT
              // =================================================

              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Đăng xuất",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

