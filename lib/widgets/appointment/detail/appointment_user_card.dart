
import 'package:flutter/material.dart';

class AppointmentUserCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String bio;
  final String? photoURL;

  // Khi bấm vào card
  final VoidCallback? onTap;

  const AppointmentUserCard({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
    this.photoURL,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        name.trim().isEmpty ? 'Unknown' : name;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // =================================================
              // AVATAR
              // =================================================

              CircleAvatar(
                radius: 40,
                backgroundImage:
                    photoURL != null &&
                            photoURL!.trim().isNotEmpty
                        ? NetworkImage(photoURL!)
                        : null,
                child:
                    photoURL == null ||
                            photoURL!.trim().isEmpty
                        ? Text(
                            displayName.isEmpty
                                ? '?'
                                : displayName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
              ),

              const SizedBox(height: 14),

              // =================================================
              // NAME
              // =================================================

              Text(
                displayName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // =================================================
              // EMAIL
              // =================================================

              if (email.trim().isNotEmpty)
                Text(
                  email,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

              const SizedBox(height: 4),

              // =================================================
              // ROLE
              // =================================================

              if (role.trim().isNotEmpty)
                Text(
                  role,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

              // =================================================
              // BIO
              // =================================================

              if (bio.trim().isNotEmpty) ...[
                const SizedBox(height: 10),

                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],

              // =================================================
              // VIEW PROFILE
              // =================================================

              if (onTap != null) ...[
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 17,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'View Profile',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

