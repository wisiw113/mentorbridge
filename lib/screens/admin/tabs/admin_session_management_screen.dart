import 'package:flutter/material.dart';

class AdminSessionManagementScreen extends StatelessWidget {
  const AdminSessionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          "Session Management",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}