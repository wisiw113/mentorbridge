import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import 'waitingApprovalScreen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController aboutController =
      TextEditingController();

  bool loading = false;

  String? selectedMajor;
  String? role;
  int? birthYear;
  String? studentYear;

  final int currentYear = DateTime.now().year;

  late final List<int> birthYears =
      List.generate(
    currentYear - 1959,
    (i) => currentYear - 18 - i,
  );

  final List<String> majors = [
    "Information Technology",
    "Computer Science",
    "Software Engineering",
    "Information Systems",
    "Artificial Intelligence",
    "Cyber Security",
    "Data Science",
    "Business Administration",
    "Marketing",
    "Finance",
    "Accounting",
    "English Language",
    "Graphic Design",
  ];

  final List<String> studentYears = [
    "Year 1",
    "Year 2",
    "Year 3",
    "Year 4",
    "Year 5+",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softMint,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  "Complete Profile",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _inputField(
                  controller: nameController,
                  hint: "Full Name",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 16),

                _roleBox(),

                const SizedBox(height: 16),

                _dropdownBirthYear(),

                const SizedBox(height: 16),

                _dropdownMajor(),

                const SizedBox(height: 16),

                _dropdownStudentYear(),

                const SizedBox(height: 16),

                if (role == "mentor")
                  _inputField(
                    controller: aboutController,
                    hint: "About Me",
                    icon: Icons.info_outline,
                    maxLines: 4,
                  ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        loading ? null : saveProfile,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.mintGreen,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get uid {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return user.uid;
  }

  Future<void> saveProfile() async {
    if (nameController.text.isEmpty ||
        role == null ||
        birthYear == null ||
        selectedMajor == null ||
        studentYear == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text("Fill all fields"),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(
        {
          "name":
              nameController.text.trim(),
          "role": role,
          "birthYear": birthYear,
          "major": selectedMajor,
          "studentYear": studentYear,
          "bio":
              aboutController.text.trim(),
          "status": "pending",
          "profileCompleted": true,
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const WaitingApprovalScreen(),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

    setState(() => loading = false);
  }

  Widget _roleBox() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          RadioListTile(
            value: "mentor",
            groupValue: role,
            title: const Text("Mentor"),
            onChanged: (value) {
              setState(() {
                role = value;
              });
            },
          ),
          RadioListTile(
            value: "mentee",
            groupValue: role,
            title: const Text("Mentee"),
            onChanged: (value) {
              setState(() {
                role = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _dropdownBirthYear() {
    return DropdownButton<int>(
      value: birthYear,
      hint: const Text("Birth Year"),
      isExpanded: true,
      items: birthYears
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.toString()),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          birthYear = value;
        });
      },
    );
  }
    Widget _dropdownMajor() {
    return DropdownButton<String>(
      value: selectedMajor,
      hint: const Text("Major"),
      isExpanded: true,
      items: majors
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedMajor = value;
        });
      },
    );
  }

  Widget _dropdownStudentYear() {
    return DropdownButton<String>(
      value: studentYear,
      hint: const Text("Student Year"),
      isExpanded: true,
      items: studentYears
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          studentYear = value;
        });
      },
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textInputAction: maxLines == 1
            ? TextInputAction.next
            : TextInputAction.newline,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          alignLabelWithHint: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              bottom: maxLines > 1 ? 70 : 0,
            ),
            child: Icon(
              icon,
              color: AppColors.mintGreen,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    super.dispose();
  }
}