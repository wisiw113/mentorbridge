import 'package:flutter/material.dart';

class MentorListContainer extends StatelessWidget {
  final List<Widget> children;

  const MentorListContainer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Color(0xFFF8FFFB), // nền mint cực nhẹ
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

        child: Column(
          children: children,
        ),
      ),
    );
  }
}