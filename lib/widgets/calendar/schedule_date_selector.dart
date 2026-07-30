import 'package:flutter/material.dart';

class ScheduleDateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String dateText;

  const ScheduleDateSelector({
    super.key,
    required this.selectedDate,
    required this.onTap,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        8,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.green.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Colors.green.shade600,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}