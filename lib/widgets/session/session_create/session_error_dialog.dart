import 'package:flutter/material.dart';

class SessionErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const SessionErrorDialog({
    super.key,
    this.title = "Không thể tạo Session",
    required this.message,
  });

  static Future<void> show(
    BuildContext context, {
    required String message,
    String title = "Không thể tạo Session",
  }) {
    return showDialog(
      context: context,
      builder: (_) => SessionErrorDialog(
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      icon: const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 48,
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Đã hiểu"),
          ),
        ),
      ],
    );
  }
}