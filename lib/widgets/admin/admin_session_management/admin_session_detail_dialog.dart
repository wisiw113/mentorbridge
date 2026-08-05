
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminSessionDetailDialog extends StatelessWidget {
  final String sessionId;

  final String title;
  final String description;
  final String mentorName;
  final String date;
  final String startTime;
  final String endTime;
  final int bookedSlots;
  final int maxSlots;
  final String status;
  final String? fileName;
  final String? fileUrl;

  const AdminSessionDetailDialog({
    super.key,
    required this.sessionId,
    required this.title,
    required this.description,
    required this.mentorName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.bookedSlots,
    required this.maxSlots,
    required this.status,
    this.fileName,
    this.fileUrl,
  });

  Color _statusColor() {
    switch (status) {
      case 'open':
        return AppColors.success;
      case 'full':
        return AppColors.warning;
      case 'running':
        return AppColors.mintGreen;
      case 'completed':
        return AppColors.completed;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.gray;
    }
  }

  String _statusText() {
    switch (status) {
      case 'open':
        return 'Open';
      case 'full':
        return 'Full';
      case 'running':
        return 'Running';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 30,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 650,
        ),
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                12,
                12,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Session Details',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.gray,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // =====================================================
            // CONTENT
            // =====================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // STATUS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusText(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // DESCRIPTION
                    if (description.isNotEmpty) ...[
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // INFO
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Mentor',
                      value: mentorName,
                    ),

                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: date,
                    ),

                    _InfoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Time',
                      value: '$startTime - $endTime',
                    ),

                    _InfoRow(
                      icon: Icons.groups_outlined,
                      label: 'Participants',
                      value: '$bookedSlots / $maxSlots',
                    ),

                    // FILE
                    if (fileName != null &&
                        fileName!.isNotEmpty) ...[
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.softMint.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              color: AppColors.deepGreen,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                fileName!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 22),

                    // =================================================
                    // PARTICIPANTS
                    // =================================================

                    const Text(
                      'Participants',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),

                    const SizedBox(height: 10),

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('session_participants')
                          .where(
                            'sessionId',
                            isEqualTo: sessionId,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.mintGreen,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text(
                            'Unable to load participants.',
                            style: TextStyle(
                              color: AppColors.error,
                            ),
                          );
                        }

                        final docs =
                            snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.softMint
                                  .withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'No participants yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.gray,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: docs.map((doc) {
                            final data = doc.data()
                                as Map<String, dynamic>;

                            final menteeName =
                                data['menteeName']?.toString() ??
                                    'Unknown mentee';

                            final participantStatus =
                                data['status']?.toString() ??
                                    'joined';

                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border
                                      .withOpacity(0.08),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.softMint
                                          .withOpacity(0.35),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      size: 20,
                                      color:
                                          AppColors.deepGreen,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      menteeName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            AppColors.darkGray,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    participantStatus,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColors.deepGreen,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.gray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

