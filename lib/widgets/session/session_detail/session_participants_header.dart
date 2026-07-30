import 'package:flutter/material.dart';

class SessionParticipantsHeader extends StatelessWidget {
  final int bookedSlots;
  final int maxSlots;

  const SessionParticipantsHeader({
    super.key,
    required this.bookedSlots,
    required this.maxSlots,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Participants",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF047857),
            ),
          ),
          Text(
            "$bookedSlots/$maxSlots",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}