import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class EditProfilePopup extends StatefulWidget {
  final String name;
  final String birthYear;
  final String gender;
  final String bio;

  final Function(
    String name,
    String birthYear,
    String gender,
    String bio,
  ) onSave;

  const EditProfilePopup({
    super.key,
    required this.name,
    required this.birthYear,
    required this.gender,
    required this.bio,
    required this.onSave,
  });

  @override
  State<EditProfilePopup> createState() =>
      _EditProfilePopupState();
}

class _EditProfilePopupState
    extends State<EditProfilePopup> {
  late TextEditingController nameController;
  late TextEditingController birthController;
  late TextEditingController bioController;

  late String selectedGender;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.name,
    );

    birthController = TextEditingController(
      text: widget.birthYear,
    );

    bioController = TextEditingController(
      text: widget.bio,
    );

    selectedGender = widget.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      // =====================================================
      // TIÊU ĐỀ
      // =====================================================

      title: const Text(
        "Chỉnh sửa hồ sơ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.deepGreen,
        ),
      ),

      // =====================================================
      // NỘI DUNG
      // =====================================================

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =================================================
            // TÊN
            // =================================================

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

            // =================================================
            // NĂM SINH
            // =================================================

            TextField(
              controller: birthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Năm sinh",
                prefixIcon: Icon(
                  Icons.cake_outlined,
                ),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // =================================================
            // GIỚI TÍNH
            // =================================================

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Giới tính",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("Nam"),
                  selected: selectedGender == "Nam",
                  selectedColor: AppColors.softMint,
                  onSelected: (_) {
                    setState(() {
                      selectedGender = "Nam";
                    });
                  },
                ),

                ChoiceChip(
                  label: const Text("Nữ"),
                  selected: selectedGender == "Nữ",
                  selectedColor: AppColors.softMint,
                  onSelected: (_) {
                    setState(() {
                      selectedGender = "Nữ";
                    });
                  },
                ),

                ChoiceChip(
                  label: const Text("Khác"),
                  selected: selectedGender == "Khác",
                  selectedColor: AppColors.softMint,
                  onSelected: (_) {
                    setState(() {
                      selectedGender = "Khác";
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // =================================================
            // GIỚI THIỆU
            // =================================================

            TextField(
              controller: bioController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Giới thiệu",
                prefixIcon: Icon(
                  Icons.info_outline,
                ),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),

      // =====================================================
      // NÚT
      // =====================================================

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Hủy"),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepGreen,
            foregroundColor: AppColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);

            widget.onSave(
              nameController.text.trim(),
              birthController.text.trim(),
              selectedGender,
              bioController.text.trim(),
            );
          },
          child: const Text("Lưu"),
        ),
      ],
    );
  }
}