
import 'package:flutter/material.dart';

class SessionParticipantActions
    extends StatelessWidget {
  final bool isLoading;
  final bool isJoined;
  final bool isFull;
  final String status;

  final VoidCallback? onJoin;
  final VoidCallback? onLeave;

  const SessionParticipantActions({
    super.key,
    required this.isLoading,
    required this.isJoined,
    required this.isFull,
    required this.status,
    required this.onJoin,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 52,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final normalizedStatus =
        status.toLowerCase();

    // =========================
    // COMPLETED
    // =========================

    if (normalizedStatus == "completed") {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.check_circle,
        ),
        label: const Text(
          "Session Completed",
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            52,
          ),
        ),
      );
    }

    // =========================
    // CANCELLED
    // =========================

    if (normalizedStatus == "cancelled") {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.cancel,
        ),
        label: const Text(
          "Session Cancelled",
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            52,
          ),
        ),
      );
    }

    // =========================
    // JOINED
    // =========================

    if (isJoined) {
      return ElevatedButton.icon(
        onPressed: onLeave,
        icon: const Icon(
          Icons.exit_to_app,
        ),
        label: const Text(
          "Leave Session",
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            52,
          ),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
      );
    }

    // =========================
    // FULL
    // =========================

    if (isFull) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.group,
        ),
        label: const Text(
          "Session Full",
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            52,
          ),
        ),
      );
    }

    // =========================
    // NOT OPEN
    // =========================

    if (normalizedStatus != "open") {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.block,
        ),
        label: const Text(
          "Session Unavailable",
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            52,
          ),
        ),
      );
    }

    // =========================
    // JOIN
    // =========================

    return ElevatedButton.icon(
      onPressed: onJoin,
      icon: const Icon(
        Icons.groups,
      ),
      label: const Text(
        "Join Session",
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          52,
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }
}

