import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class BookingTopicSelector extends StatelessWidget {
  final String? selectedTopic;
  final ValueChanged<String> onChanged;

  const BookingTopicSelector({
    super.key,
    required this.selectedTopic,
    required this.onChanged,
  });

  static const List<String> topics = [
    "Học tập",
    "Định hướng nghề nghiệp",
    "CV",
    "Phỏng vấn",
    "Lập trình",
    "Đồ án",
    "Khác",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          "Nội dung tư vấn",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: topics.map((topic) {
            final selected =
                topic == selectedTopic;

            return ChoiceChip(
              label: Text(topic),
              selected: selected,
              onSelected: (_) =>
                  onChanged(topic),
              selectedColor:
                  AppColors.mintGreen,
              backgroundColor:
                  Colors.white,
              labelStyle: TextStyle(
                color: selected
                    ? Colors.white
                    : AppColors.darkGray,
                fontWeight:
                    FontWeight.w600,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        30),
                side: BorderSide(
                  color: selected
                      ? AppColors.mintGreen
                      : AppColors.border,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}