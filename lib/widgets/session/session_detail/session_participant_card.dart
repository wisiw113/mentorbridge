
import 'package:flutter/material.dart';

class ParticipantCard extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? joinedAt;

  final VoidCallback? onTap;
  final VoidCallback? onKick;

  const ParticipantCard({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.joinedAt,
    this.onTap,
    this.onKick,
  });

  // =========================================================
  // FORMAT JOINED TIME
  // =========================================================

  String _formatJoinedAt() {
    if (joinedAt == null) {
      return 'Không rõ thời gian';
    }

    final date = joinedAt!;

    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    final hour =
        date.hour.toString().padLeft(2, '0');

    final minute =
        date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} • $hour:$minute';
  }

  // =========================================================
  // DISPLAY NAME
  // =========================================================

  String _displayName() {
    final value = name.trim();

    if (value.isEmpty) {
      return 'Mentee';
    }

    return value;
  }

  // =========================================================
  // DISPLAY EMAIL
  // =========================================================

  String _displayEmail() {
    final value = email.trim();

    if (value.isEmpty) {
      return 'Email chưa cập nhật';
    }

    return value;
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final displayName = _displayName();
    final displayEmail = _displayEmail();

    final hasAvatar =
        avatarUrl != null &&
        avatarUrl!.trim().isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [

              // =================================================
              // AVATAR
              // =================================================

              CircleAvatar(
                radius: 25,
                backgroundColor:
                    const Color(0xFFD1FAE5),

                backgroundImage: hasAvatar
                    ? NetworkImage(
                        avatarUrl!.trim(),
                      )
                    : null,

                child: !hasAvatar
                    ? Text(
                        displayName[0]
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF047857),
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              // =================================================
              // INFORMATION
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // =================================================
                    // NAME
                    // =================================================

                    Text(
                      displayName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // =================================================
                    // EMAIL
                    // =================================================

                    Row(
                      children: [

                        const Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            displayEmail,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // =================================================
                    // JOINED TIME
                    // =================================================

                    Row(
                      children: [

                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),

                        const SizedBox(width: 4),

                        Flexible(
                          child: Text(
                            'Joined: ${_formatJoinedAt()}',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // =================================================
              // KICK BUTTON
              // =================================================

              if (onKick != null) ...[
                const SizedBox(width: 8),

                IconButton(
                  tooltip: 'Kick mentee',
                  onPressed: onKick,
                  style:
                      IconButton.styleFrom(
                    backgroundColor:
                        Colors.red.withValues(
                      alpha: 0.08,
                    ),
                    foregroundColor: Colors.red,
                    padding:
                        const EdgeInsets.all(
                      10,
                    ),
                  ),
                  icon: const Icon(
                    Icons
                        .person_remove_outlined,
                    size: 21,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

