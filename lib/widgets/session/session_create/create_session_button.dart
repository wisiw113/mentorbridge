import 'package:flutter/material.dart';

class SessionCreateButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const SessionCreateButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Create Session",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}