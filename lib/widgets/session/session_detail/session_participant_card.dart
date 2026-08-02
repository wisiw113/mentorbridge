
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
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // =================================================
              // AVATAR
              // =================================================

              CircleAvatar(
                radius: 25,
                backgroundColor:
                    const Color(0xFFD1FAE5),
                backgroundImage:
                    avatarUrl != null &&
                            avatarUrl!.isNotEmpty
                        ? NetworkImage(avatarUrl!)
                        : null,
                child:
                    avatarUrl == null ||
                            avatarUrl!.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Color(0xFF047857),
                            size: 28,
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

                    // NAME
                    Text(
                      name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // EMAIL / ID
                    Text(
                      email,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // JOINED TIME
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
                            style: const TextStyle(
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
              // Chỉ xuất hiện khi onKick != null
              // =================================================

              if (onKick != null) ...[
                const SizedBox(width: 8),

                IconButton(
                  tooltip: 'Kick mentee',
                  onPressed: onKick,

                  style: IconButton.styleFrom(
                    backgroundColor:
                        Colors.red.withOpacity(0.08),
                    foregroundColor: Colors.red,
                    padding:
                        const EdgeInsets.all(10),
                  ),

                  icon: const Icon(
                    Icons.person_remove_outlined,
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

