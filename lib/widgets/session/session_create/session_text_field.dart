import 'package:flutter/material.dart';

class SessionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const SessionTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}