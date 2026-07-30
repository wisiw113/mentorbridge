import 'package:flutter/material.dart';

class EditProfilePopup extends StatefulWidget {
  // ================= COMMON =================

  final String name;
  final String birthYear;
  final String gender;

  // ================= ROLE =================

  final String role;

  // ================= MENTOR =================

  final String specialization;
  final String experience;
  final String skills;

  // ================= MENTEE =================

  final String interests;
  final String learningGoals;

  // ================= CALLBACK =================

  final Function(
    String name,
    String birthYear,
    String gender,
    String specialization,
    String experience,
    String skills,
    String interests,
    String learningGoals,
  ) onSave;

  const EditProfilePopup({
    super.key,

    // Common
    required this.name,
    required this.birthYear,
    required this.gender,

    // Role
    required this.role,

    // Mentor
    this.specialization = "",
    this.experience = "",
    this.skills = "",

    // Mentee
    this.interests = "",
    this.learningGoals = "",

    // Save
    required this.onSave,
  });

  @override
  State<EditProfilePopup> createState() {
    return _EditProfilePopupState();
  }
}

class _EditProfilePopupState
    extends State<EditProfilePopup> {
  // ================= CONTROLLERS =================

  late TextEditingController nameController;

  late TextEditingController birthController;

  late TextEditingController specializationController;

  late TextEditingController experienceController;

  late TextEditingController skillsController;

  late TextEditingController interestsController;

  late TextEditingController learningGoalsController;

  // ================= STATE =================

  late String selectedGender;

  @override
  void initState() {
    super.initState();

    // Common
    nameController = TextEditingController(
      text: widget.name,
    );

    birthController = TextEditingController(
      text: widget.birthYear,
    );

    selectedGender = widget.gender;

    // Mentor
    specializationController =
        TextEditingController(
      text: widget.specialization,
    );

    experienceController =
        TextEditingController(
      text: widget.experience,
    );

    skillsController =
        TextEditingController(
      text: widget.skills,
    );

    // Mentee
    interestsController =
        TextEditingController(
      text: widget.interests,
    );

    learningGoalsController =
        TextEditingController(
      text: widget.learningGoals,
    );
  }

  @override
  void dispose() {
    nameController.dispose();

    birthController.dispose();

    specializationController.dispose();

    experienceController.dispose();

    skillsController.dispose();

    interestsController.dispose();

    learningGoalsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMentor =
        widget.role.toLowerCase() == "mentor";

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      title: const Text(
        "Chỉnh sửa Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // ================= COMMON =================

            TextField(
              controller: nameController,

              decoration: const InputDecoration(
                labelText: "Tên",

                prefixIcon: Icon(
                  Icons.person_outline,
                ),

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: birthController,

              keyboardType:
                  TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Năm sinh",

                prefixIcon: Icon(
                  Icons.cake_outlined,
                ),

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // ================= GENDER =================

            Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "Giới tính",

                style: TextStyle(
                  fontWeight: FontWeight.w600,

                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                ChoiceChip(
                  label: const Text("Nam"),

                  selected:
                      selectedGender == "Nam",

                  onSelected: (_) {
                    setState(() {
                      selectedGender = "Nam";
                    });
                  },
                ),

                const SizedBox(width: 10),

                ChoiceChip(
                  label: const Text("Nữ"),

                  selected:
                      selectedGender == "Nữ",

                  onSelected: (_) {
                    setState(() {
                      selectedGender = "Nữ";
                    });
                  },
                ),

                const SizedBox(width: 10),

                ChoiceChip(
                  label: const Text("Khác"),

                  selected:
                      selectedGender == "Khác",

                  onSelected: (_) {
                    setState(() {
                      selectedGender = "Khác";
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= ROLE TITLE =================

            Align(
              alignment: Alignment.centerLeft,

              child: Text(
                isMentor
                    ? "Thông tin Mentor"
                    : "Thông tin Mentee",

                style: const TextStyle(
                  fontSize: 16,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ================= MENTOR =================

            if (isMentor) ...[
              TextField(
                controller:
                    specializationController,

                decoration:
                    const InputDecoration(
                  labelText: "Chuyên môn",

                  prefixIcon: Icon(
                    Icons.work_outline,
                  ),

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller:
                    experienceController,

                decoration:
                    const InputDecoration(
                  labelText: "Kinh nghiệm",

                  prefixIcon: Icon(
                    Icons.timeline,
                  ),

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: skillsController,

                maxLines: 3,

                decoration:
                    const InputDecoration(
                  labelText: "Kỹ năng",

                  prefixIcon: Icon(
                    Icons.star_outline,
                  ),

                  border:
                      OutlineInputBorder(),
                ),
              ),
            ]

            // ================= MENTEE =================

            else ...[
              TextField(
                controller: interestsController,

                maxLines: 3,

                decoration:
                    const InputDecoration(
                  labelText: "Sở thích",

                  prefixIcon: Icon(
                    Icons.interests_outlined,
                  ),

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller:
                    learningGoalsController,

                maxLines: 3,

                decoration:
                    const InputDecoration(
                  labelText: "Mục tiêu học tập",

                  prefixIcon: Icon(
                    Icons.flag_outlined,
                  ),

                  border:
                      OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),

      actions: [
        // ================= CANCEL =================

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },

          child: const Text(
            "Hủy",
          ),
        ),

        // ================= SAVE =================

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);

            widget.onSave(
              nameController.text.trim(),

              birthController.text.trim(),

              selectedGender,

              specializationController.text.trim(),

              experienceController.text.trim(),

              skillsController.text.trim(),

              interestsController.text.trim(),

              learningGoalsController.text.trim(),
            );
          },

          child: const Text(
            "Lưu",
          ),
        ),
      ],
    );
  }
}