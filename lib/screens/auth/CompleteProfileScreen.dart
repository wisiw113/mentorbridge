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

  class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
    final nameController = TextEditingController();

    bool loading = false;

    String? selectedMajor;
    String? role;
    int? birthYear;
    String? studentYear;

    final int currentYear = DateTime.now().year;

    late final List<int> birthYears =
        List.generate(currentYear - 1959, (i) => currentYear - 18 - i);

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

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mintGreen,
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
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

    // 🔥 FIX: LẤY UID AN TOÀN
    String get uid {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");
      return user.uid;
    }

    Future<void> saveProfile() async {
      if (nameController.text.isEmpty ||
          role == null ||
          birthYear == null ||
          selectedMajor == null ||
          studentYear == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill all fields")),
        );
        return;
      }

      setState(() => loading = true);

      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set({
          "name": nameController.text.trim(),
          "role": role,
          "birthYear": birthYear,
          "major": selectedMajor,
          "studentYear": studentYear,

          // 🔥 SYSTEM FLOW CHUẨN
          "status": "pending",
          "profileCompleted": true,
        }, SetOptions(merge: true));

        if (!mounted) return;

        // 🔥 CHUYỂN MÀN SAU KHI SAVE
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const WaitingApprovalScreen(),
          ),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }

      setState(() => loading = false);
    }

    // ---------------- UI ----------------

    Widget _roleBox() {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            RadioListTile(
              value: "mentor",
              groupValue: role,
              title: const Text("Mentor"),
              onChanged: (v) => setState(() => role = v),
            ),
            RadioListTile(
              value: "mentee",
              groupValue: role,
              title: const Text("Mentee"),
              onChanged: (v) => setState(() => role = v),
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
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString()),
                ))
            .toList(),
        onChanged: (v) => setState(() => birthYear = v),
      );
    }

    Widget _dropdownMajor() {
      return DropdownButton<String>(
        value: selectedMajor,
        hint: const Text("Major"),
        isExpanded: true,
        items: majors
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: (v) => setState(() => selectedMajor = v),
      );
    }

    Widget _dropdownStudentYear() {
      return DropdownButton<String>(
        value: studentYear,
        hint: const Text("Student Year"),
        isExpanded: true,
        items: studentYears
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: (v) => setState(() => studentYear = v),
      );
    }

    Widget _inputField({
      required TextEditingController controller,
      required String hint,
      required IconData icon,
    }) {
      return Container(
        color: Colors.white,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.mintGreen),
            border: InputBorder.none,
          ),
        ),
      );
    }

    @override
    void dispose() {
      nameController.dispose();
      super.dispose();
    }
  }