import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class BookingTimeSelector extends StatelessWidget {
  final String? selectedTime;
  final ValueChanged<String> onChanged;

  const BookingTimeSelector({
    super.key,
    required this.selectedTime,
    required this.onChanged,
  });

  static const List<String> timeSlots = [
    "08:00 - 10:00",
    "10:00 - 12:00",
    "13:00 - 15:00",
    "15:00 - 17:00",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          "Khung giờ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),

        const SizedBox(height: 10),

        ...timeSlots.map(
          (slot) {
            return Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedTime == slot
                      ? AppColors.mintGreen
                      : AppColors.border,
                ),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: RadioListTile<String>(
                value: slot,
                groupValue: selectedTime,
                activeColor:
                    AppColors.mintGreen,
                title: Text(slot),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}