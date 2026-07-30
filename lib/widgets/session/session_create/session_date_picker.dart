import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const SessionDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Session Date",
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          selectedDate == null
              ? "Select date"
              : DateFormat(
                  "dd/MM/yyyy",
                ).format(selectedDate!),
          style: TextStyle(
            color: selectedDate == null
                ? Colors.grey
                : Colors.black,
          ),
        ),
      ),
    );
  }
}