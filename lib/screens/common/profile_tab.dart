import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/edit_profile_popup.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // ================= COMMON =================

  String name = "";
  String role = "";
  String email = "";
  String gender = "";

  String? photoURL;

  int? birthYear;

  // ================= MENTOR =================

  String specialization = "";
  String experience = "";
  String skills = "";

  // ================= MENTEE =================

  String interests = "";
  String learningGoals = "";

  bool isUploading = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // ================= LOAD USER =================

  Future<void> loadUser() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final data = doc.data();

      if (data == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (!mounted) return;

      setState(() {
        // Common
        name = data['name']?.toString() ?? "";

        role = data['role']?.toString() ?? "";

        email =
            FirebaseAuth.instance.currentUser?.email ?? "";

        gender = data['gender']?.toString() ?? "";

        photoURL = data['photoURL']?.toString();

        birthYear = data['birthYear'] is int
            ? data['birthYear']
            : int.tryParse(
                data['birthYear']?.toString() ?? "",
              );

        // Mentor
        specialization =
            data['specialization']?.toString() ?? "";

        experience =
            data['experience']?.toString() ?? "";

        skills =
            data['skills']?.toString() ?? "";

        // Mentee
        interests =
            data['interests']?.toString() ?? "";

        learningGoals =
            data['learningGoals']?.toString() ?? "";

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

  // ================= CLOUDINARY =================

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

    request.fields['upload_preset'] =
        uploadPreset;

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

  // ================= PICK IMAGE =================

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
                Navigator.pop(
                  context,
                  false,
                );
              },

              child: const Text(
                "Hủy",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },

              child: const Text(
                "OK",
              ),
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
      final url =
          await uploadToCloudinary(bytes);

      if (url != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(
          {
            'photoURL': url,
          },
          SetOptions(
            merge: true,
          ),
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

  // ================= EDIT PROFILE =================

  void editProfileDialog() {
    showDialog(
      context: context,

      builder: (_) {
        return EditProfilePopup(
          // Common
          name: name,

          birthYear:
              birthYear?.toString() ?? "",

          gender: gender,

          // Role
          role: role,

          // Mentor
          specialization:
              specialization,

          experience:
              experience,

          skills:
              skills,

          // Mentee
          interests:
              interests,

          learningGoals:
              learningGoals,

          onSave: (
            newName,
            newBirthYear,
            newGender,
            newSpecialization,
            newExperience,
            newSkills,
            newInterests,
            newLearningGoals,
          ) async {
            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .set(
                {
                  // Common
                  'name': newName,

                  'birthYear':
                      int.tryParse(
                    newBirthYear,
                  ),

                  'gender': newGender,

                  // Mentor
                  'specialization':
                      newSpecialization,

                  'experience':
                      newExperience,

                  'skills': newSkills,

                  // Mentee
                  'interests':
                      newInterests,

                  'learningGoals':
                      newLearningGoals,
                },
                SetOptions(
                  merge: true,
                ),
              );

              await loadUser();

              if (!mounted) return;

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Cập nhật profile thành công",
                  ),
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                  .showSnackBar(
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

  // ================= LOGOUT =================

  Future<void> logout() async {
    final confirm = await showConfirmDialog(
      context,

      title: "Logout",

      content:
          "Are you sure you want to logout?",
    );

    if (!confirm) return;

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      "/login",
    );
  }

  // ================= UI =================

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
      backgroundColor:
          const Color(0xFFF8F9FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 30,
          ),

          child: Column(
            children: [
              const SizedBox(height: 25),

              // ================= AVATAR =================

              Stack(
                alignment:
                    Alignment.bottomRight,

                children: [
                  CircleAvatar(
                    radius: 60,

                    backgroundColor:
                        Colors.grey.shade300,

                    backgroundImage:
                        photoURL != null
                            ? NetworkImage(
                                photoURL!,
                              )
                            : null,

                    child: photoURL == null
                        ? Text(
                            name.isNotEmpty
                                ? name[0]
                                    .toUpperCase()
                                : "?",

                            style:
                                const TextStyle(
                              fontSize: 30,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          )
                        : null,
                  ),

                  GestureDetector(
                    onTap:
                        pickAndUploadImage,

                    child: Container(
                      padding:
                          const EdgeInsets.all(
                        8,
                      ),

                      decoration:
                          const BoxDecoration(
                        color: Colors.black,

                        shape:
                            BoxShape.circle,
                      ),

                      child: isUploading
                          ? const SizedBox(
                              width: 16,

                              height: 16,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,

                                color:
                                    Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons
                                  .camera_alt,
                              size: 17,

                              color:
                                  Colors.white,
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ================= NAME =================

              Text(
                name.isEmpty
                    ? "User"
                    : name,

                style: const TextStyle(
                  fontSize: 23,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                email,

                style: const TextStyle(
                  color: Colors.grey,

                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              // ================= BASIC INFO =================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,

                children: [
                  _stat(
                    title: "Role",

                    value: role,
                  ),

                  _stat(
                    title: "Birth Year",

                    value: birthYear
                            ?.toString() ??
                        "-",
                  ),

                  _stat(
                    title: "Gender",

                    value: gender.isEmpty
                        ? "-"
                        : gender,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ================= ROLE INFO =================

              if (role.toLowerCase() ==
                  "mentor")
                _buildMentorInfo(),

              if (role.toLowerCase() ==
                  "mentee")
                _buildMenteeInfo(),

              const SizedBox(height: 25),

              // ================= BUTTONS =================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Column(
                  children: [
                    SizedBox(
                      width:
                          double.infinity,

                      child:
                          ElevatedButton.icon(
                        onPressed:
                            editProfileDialog,

                        icon: const Icon(
                          Icons
                              .edit_outlined,
                          size: 18,
                        ),

                        label: const Text(
                          "Edit Profile",
                        ),

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              Colors.black,

                          foregroundColor:
                              Colors.white,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 14,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              30,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    SizedBox(
                      width:
                          double.infinity,

                      child:
                          OutlinedButton.icon(
                        onPressed: logout,

                        icon: const Icon(
                          Icons.logout,
                          size: 18,
                        ),

                        label: const Text(
                          "Logout",
                        ),

                        style:
                            OutlinedButton
                                .styleFrom(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 14,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= MENTOR INFO =================

  Widget _buildMentorInfo() {
    return _infoCard(
      title: "Mentor Information",

      children: [
        _infoRow(
          Icons.work_outline,
          "Specialization",
          specialization,
        ),

        _infoRow(
          Icons.timeline,
          "Experience",
          experience,
        ),

        _infoRow(
          Icons.star_outline,
          "Skills",
          skills,
        ),
      ],
    );
  }

  // ================= MENTEE INFO =================

  Widget _buildMenteeInfo() {
    return _infoCard(
      title: "Learning Information",

      children: [
        _infoRow(
          Icons.interests_outlined,
          "Interests",
          interests,
        ),

        _infoRow(
          Icons.flag_outlined,
          "Learning Goals",
          learningGoals,
        ),
      ],
    );
  }

  // ================= INFO CARD =================

  Widget _infoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 17,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          ...children,
        ],
      ),
    );
  }

  // ================= INFO ROW =================

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

            size: 21,

            color: Colors.grey.shade700,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontSize: 12,

                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.isEmpty
                      ? "-"
                      : value,

                  style:
                      const TextStyle(
                    fontSize: 14,

                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STAT =================

  Widget _stat({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value.isEmpty
              ? "-"
              : value,

          style: const TextStyle(
            fontSize: 16,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,

          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}