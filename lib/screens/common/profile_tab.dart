import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/edit_profile_popup.dart';
import '../../../widgets/profile_tab/profile_action_buttons.dart';
import '../../../widgets/profile_tab/profile_avatar.dart';
import '../../../widgets/profile_tab/profile_header.dart';
import '../../../widgets/profile_tab/profile_stats.dart';

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
  String gender = "";

  String? photoURL;

  int? birthYear;

  String major = "";
  String studentYear = "";
  String bio = "";

  bool isUploading = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final data = doc.data();

      if (data == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        return;
      }

      if (!mounted) return;

      setState(() {
        name = data['name']?.toString() ?? "";
        role = data['role']?.toString() ?? "";
        email = FirebaseAuth.instance.currentUser?.email ?? "";
        gender = data['gender']?.toString() ?? "";
        photoURL = data['photoURL']?.toString();

        birthYear = data['birthYear'] is int
            ? data['birthYear']
            : int.tryParse(
                data['birthYear']?.toString() ?? "",
              );

        major = data['major']?.toString() ?? "";
        studentYear = data['studentYear']?.toString() ?? "";
        bio = data['bio']?.toString() ?? "";

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Không thể tải thông tin người dùng: $e",
          ),
        ),
      );
    }
  }

  Future<String?> uploadToCloudinary(
    Uint8List bytes,
  ) async {
    const cloudName = "waobnfz0";
    const uploadPreset = "flutter_upload";

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/"
      "$cloudName/image/upload",
    );

    final request = http.MultipartRequest(
      "POST",
      url,
    );

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        bytes,
        filename: "avatar.jpg",
      ),
    );

    final response = await request.send();

    final responseBody =
        await response.stream.bytesToString();

    final data = json.decode(responseBody);

    if (response.statusCode == 200 &&
        data["secure_url"] != null) {
      return data["secure_url"];
    }

    return null;
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Xác nhận ảnh đại diện",
          ),
          content: Image.memory(
            bytes,
            height: 200,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      isUploading = true;
    });

    try {
      final url = await uploadToCloudinary(bytes);

      if (url != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(
          {
            'photoURL': url,
          },
          SetOptions(merge: true),
        );

        if (!mounted) return;

        setState(() {
          photoURL = url;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Upload ảnh thất bại: $e",
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isUploading = false;
    });
  }

  void editProfileDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return EditProfilePopup(
          name: name,
          birthYear: birthYear?.toString() ?? "",
          gender: gender,
          bio: bio,
          onSave: (
            newName,
            newBirthYear,
            newGender,
            newBio,
          ) async {
            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .set(
                {
                  'name': newName,
                  'birthYear': int.tryParse(
                    newBirthYear,
                  ),
                  'gender': newGender,
                  'bio': newBio,
                },
                SetOptions(merge: true),
              );

              await loadUser();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Cập nhật profile thành công",
                  ),
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Cập nhật thất bại: $e",
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> logout() async {
    final confirm = await showConfirmDialog(
      context,
      title: "Logout",
      content: "Are you sure you want to logout?",
    );

    if (!confirm) return;

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      "/login",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.softMint,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 30,
          ),
          child: Column(
            children: [
              const SizedBox(height: 25),

              ProfileAvatar(
                name: name,
                photoURL: photoURL,
                isUploading: isUploading,
                onCameraTap: pickAndUploadImage,
              ),

              const SizedBox(height: 12),

              ProfileHeader(
                name: name,
                email: email,
              ),

              const SizedBox(height: 25),

              ProfileStats(
                role: role,
                birthYear: birthYear,
                gender: gender,
              ),

              const SizedBox(height: 25),

              _buildProfileInfo(),

              const SizedBox(height: 25),

              ProfileActionButtons(
                onEdit: editProfileDialog,
                onLogout: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Information",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),

          const SizedBox(height: 16),

          _infoRow(
            Icons.school_outlined,
            "Major",
            major,
          ),

          _infoRow(
            Icons.menu_book_outlined,
            "Student Year",
            studentYear,
          ),

          _infoRow(
            Icons.info_outline,
            "About Me",
            bio,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.deepGreen,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.isEmpty ? "-" : value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

