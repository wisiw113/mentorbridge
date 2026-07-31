
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/appointment_model.dart';
import '../../models/appointment_rating_model.dart';
import '../../services/appointment_rating_service.dart';

class AppointmentRequestCard extends StatelessWidget {
final AppointmentModel appointment;

final VoidCallback? onAccept;
final VoidCallback? onReject;
final VoidCallback? onComplete;

final bool canComplete;

AppointmentRequestCard({
super.key,
required this.appointment,
this.onAccept,
this.onReject,
this.onComplete,
this.canComplete = false,
});

final AppointmentRatingService _ratingService =
AppointmentRatingService();

@override
Widget build(BuildContext context) {
final status = appointment.status.toLowerCase();


return Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  ),
  elevation: 2,
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: const BorderSide(
      color: Colors.black,
      width: 1.2,
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =================================================
        // HEADER
        // =================================================

        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green.shade50,
              child: Icon(
                Icons.person_outline,
                color: Colors.green.shade700,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.menteeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Appointment Request",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            _buildStatusBadge(),
          ],
        ),

        const SizedBox(height: 18),

        // =================================================
        // DATE
        // =================================================

        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: "Ngày",
          value: appointment.date,
        ),

        const SizedBox(height: 10),

        // =================================================
        // TIME
        // =================================================

        _InfoRow(
          icon: Icons.access_time_outlined,
          label: "Thời gian",
          value: appointment.time,
        ),

        // =================================================
        // TOPIC
        // =================================================

        if (appointment.topic.trim().isNotEmpty) ...[
          const SizedBox(height: 10),

          _InfoRow(
            icon: Icons.topic_outlined,
            label: "Chủ đề",
            value: appointment.topic,
          ),
        ],

        // =================================================
        // NOTE
        // =================================================

        if (appointment.note.trim().isNotEmpty) ...[
          const SizedBox(height: 10),

          _InfoRow(
            icon: Icons.notes_outlined,
            label: "Ghi chú",
            value: appointment.note,
          ),
        ],

        // =================================================
        // REJECT REASON
        // =================================================

        if (status == "rejected" &&
            appointment.rejectReason != null &&
            appointment.rejectReason!
                .trim()
                .isNotEmpty) ...[
          const SizedBox(height: 14),

          _InfoRow(
            icon: Icons.info_outline,
            label: "Lý do",
            value: appointment.rejectReason!,
          ),
        ],

        // =================================================
        // RATING + REVIEW
        // =================================================

        if (status == "completed") ...[
          const SizedBox(height: 14),

          _buildRatingSection(),
        ],

        // =================================================
        // PENDING ACTIONS
        // =================================================

        if (status == "pending") ...[
          const SizedBox(height: 18),

          Row(
            children: [
              // =========================
              // REJECT
              // =========================

              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(
                      color: Colors.red,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Reject",
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // =========================
              // ACCEPT
              // =========================

              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.grey.shade300,
                    disabledForegroundColor:
                        Colors.grey.shade600,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Accept",
                  ),
                ),
              ),
            ],
          ),
        ],

        // =================================================
        // COMPLETE
        // =================================================

        if (status == "accepted") ...[
          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  canComplete
                      ? onComplete
                      : null,
              icon: const Icon(
                Icons.check_circle_outline,
              ),
              label: Text(
                canComplete
                    ? "Complete"
                    : "Chưa đến thời gian hoàn thành",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    Colors.grey.shade200,
                disabledForegroundColor:
                    Colors.grey.shade600,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  ),
);


}

// =========================================================
// RATING SECTION
// =========================================================

Widget _buildRatingSection() {
return FutureBuilder<AppointmentRatingModel?>(
future: _ratingService.getRatingByAppointment(
appointment.id,
),
builder: (context, snapshot) {
// =====================================================
// LOADING
// =====================================================


    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey.shade400,
            ),
          ),

          const SizedBox(width: 8),

          Text(
            "Đang tải đánh giá...",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    // =====================================================
    // ERROR
    // =====================================================

    if (snapshot.hasError) {
      return Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.grey.shade400,
            size: 20,
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              "Không thể tải đánh giá",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }

    // =====================================================
    // GET RATING
    // =====================================================

    final rating = snapshot.data;

    // =====================================================
    // NO RATING
    // =====================================================

    if (rating == null) {
      return Row(
        children: [
          Icon(
            Icons.star_border,
            color: Colors.grey.shade400,
            size: 20,
          ),

          const SizedBox(width: 6),

          Text(
            "Chưa có đánh giá",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    // =====================================================
    // RATING + REVIEW
    // =====================================================

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =========================
          // TITLE
          // =========================

          Text(
            "Đánh giá từ Mentee",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 8),

          // =========================
          // STAR RATING
          // =========================

          Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) {
                    final roundedRating =
                        rating.rating.round();

                    return Icon(
                      index < roundedRating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 22,
                    );
                  },
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "${rating.rating.toStringAsFixed(1)}/5",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // =========================
          // REVIEW
          // =========================

          if (rating.comment.trim().isNotEmpty) ...[
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      rating.comment,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  },
);


}

// =========================================================
// STATUS BADGE
// =========================================================

Widget _buildStatusBadge() {
final status =
appointment.status.toLowerCase();

Color color;
String text;

switch (status) {
  case "accepted":
    color = AppColors.accepted;
    text = "Accepted";
    break;

  case "rejected":
    color = AppColors.cancelled;
    text = "Rejected";
    break;

  case "completed":
  case "complete":
    color = AppColors.completed;
    text = "Completed";
    break;

  default:
    color = AppColors.pending;
    text = "Pending";
}

return Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 5,
  ),
  decoration: BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius:
        BorderRadius.circular(20),
  ),
  child: Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
  ),
);


}
}

// =========================================================
// INFO ROW
// =========================================================

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
return Row(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Icon(
icon,
size: 18,
color: Colors.grey.shade600,
),


    const SizedBox(width: 10),

    Text(
      "$label: ",
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 13,
      ),
    ),

    Expanded(
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ],
);

}
}
