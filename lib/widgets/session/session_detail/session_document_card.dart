import 'package:flutter/material.dart';

class SessionDocumentCard extends StatelessWidget {
  final String? fileName;
  final VoidCallback onTap;

  const SessionDocumentCard({
    super.key,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(
              Icons.description_outlined,
              color: Color(0xFF047857),
            ),
          ),
          title: Text(
            fileName ?? "Session Document",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text(
            "Tap to download",
          ),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}