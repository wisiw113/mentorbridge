import 'package:flutter/material.dart';

class MentorCard extends StatefulWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final double rating;
  final int reviewCount;
  final VoidCallback onTap;

  const MentorCard({
    super.key,
    required this.name,
    required this.email,
    required this.onTap,
    this.avatarUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  @override
  State<MentorCard> createState() => _MentorCardState();
}

class _MentorCardState extends State<MentorCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..scale(isPressed ? 0.98 : 1.0),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF8FFFB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF10B981),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEFFDF5),
                backgroundImage:
                    widget.avatarUrl != null &&
                            widget.avatarUrl!.isNotEmpty
                        ? NetworkImage(widget.avatarUrl!)
                        : null,
                child: widget.avatarUrl == null ||
                        widget.avatarUrl!.isEmpty
                    ? Text(
                        widget.name.isNotEmpty
                            ? widget.name[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF047857),
                        ),
                      )
                    : null,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) {
                          if (index < widget.rating.floor()) {
                            return const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            );
                          }

                          if (index < widget.rating) {
                            return const Icon(
                              Icons.star_half,
                              size: 16,
                              color: Colors.amber,
                            );
                          }

                          return const Icon(
                            Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        },
                      ),

                      const SizedBox(width: 5),

                      Text(
                        widget.reviewCount == 0
                            ? "Chưa có đánh giá"
                            : "${widget.rating.toStringAsFixed(1)} (${widget.reviewCount})",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                const Color(0xFF10B981),
                            width: 0.5,
                          ),
                        ),
                        child: const Text(
                          "Mentor",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF047857),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.verified,
                        size: 14,
                        color: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}