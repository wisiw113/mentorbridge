import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/models/appointment_model.dart';
import 'package:flutter_application_1/models/appointment_rating_model.dart';

import 'package:flutter_application_1/services/appointment_service.dart';
import 'package:flutter_application_1/services/appointment_rating_service.dart';

import 'package:flutter_application_1/widgets/common/rating_popup.dart';
import 'package:flutter_application_1/widgets/appointment/appointment_detail_popup.dart';

class PendingTab extends StatelessWidget {
PendingTab({super.key});

final AppointmentService _appointmentService =
AppointmentService();

final AppointmentRatingService _ratingService =
AppointmentRatingService();

@override
Widget build(BuildContext context) {
final user = FirebaseAuth.instance.currentUser;


if (user == null) {
  return const Center(
    child: Text("Chưa đăng nhập"),
  );
}

return StreamBuilder<List<AppointmentModel>>(
  stream: _appointmentService.getMenteeAppointments(
    user.uid,
  ),
  builder: (context, snapshot) {
    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(
          "Lỗi: ${snapshot.error}",
        ),
      );
    }

    if (!snapshot.hasData ||
        snapshot.data!.isEmpty) {
      return const Center(
        child: Text("Chưa có lịch hẹn"),
      );
    }

    final list = snapshot.data!;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        final status = item.status.toLowerCase();

        final isCompleted =
            status == "completed" ||
            status == "complete";

        Color color;
        IconData icon;
        String statusText;

        switch (status) {
          case "accepted":
            color = Colors.green;
            icon = Icons.check_circle;
            statusText = "Đã chấp nhận";
            break;

          case "rejected":
            color = Colors.red;
            icon = Icons.cancel;
            statusText = "Bị từ chối";
            break;

          case "completed":
          case "complete":
            color = Colors.blue;
            icon = Icons.verified;
            statusText = "Đã hoàn thành";
            break;

          default:
            color = Colors.orange;
            icon = Icons.access_time;
            statusText = "Đang chờ";
        }

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(
            bottom: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              _showAppointmentDetail(
                context,
                item,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // MENTOR NAME
                  // =================================================

                  Text(
                    item.mentorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // =================================================
                  // DATE
                  // =================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(item.date),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // =================================================
                  // TIME
                  // =================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(item.time),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // =================================================
                  // NOTE
                  // =================================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.notes,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.note.isEmpty
                              ? "Không có ghi chú"
                              : item.note,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // STATUS + RATING
                  // =================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      // STATUS
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              color.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              color: color,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: color,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // RATING BUTTON
                      if (isCompleted &&
                          !item.rated)
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.star,
                          ),
                          label: const Text(
                            "Đánh giá",
                          ),
                          onPressed: () async {
                            await _showRatingDialog(
                              context,
                              item,
                              user.uid,
                            );
                          },
                        ),

                      // ALREADY RATED
                      if (isCompleted &&
                          item.rated)
                        const Chip(
                          avatar: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                          label: Text(
                            "Đã đánh giá",
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  },
);


}

// =========================================================
// APPOINTMENT DETAIL
// =========================================================

void _showAppointmentDetail(
BuildContext context,
AppointmentModel appointment,
) {
showModalBottomSheet(
context: context,
isScrollControlled: true,
backgroundColor: Colors.white,
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(
top: Radius.circular(24),
),
),
builder: (context) {
return AppointmentDetailPopup(
appointment: appointment,
);
},
);
}

// =========================================================
// RATING + REVIEW
// =========================================================

Future<void> _showRatingDialog(
BuildContext context,
AppointmentModel appointment,
String menteeId,
) async {
// RatingPopup trả về:
//
// {
//   "rating": int,
//   "comment": String,
// }


final result =
    await showDialog<Map<String, dynamic>>(
  context: context,
  builder: (_) => const RatingPopup(),
);

// Người dùng bấm Hủy
if (result == null) {
  return;
}

final ratingValue = result["rating"];

final commentValue = result["comment"];

if (ratingValue == null) {
  return;
}

final int rating =
    ratingValue is int
        ? ratingValue
        : int.tryParse(
              ratingValue.toString(),
            ) ??
            0;

final String comment =
    commentValue?.toString().trim() ?? "";

if (rating < 1 || rating > 5) {
  return;
}

try {
  // =====================================================
  // CHECK ALREADY RATED
  // =====================================================

  final alreadyRated =
      await _ratingService.hasRated(
    appointmentId: appointment.id,
    menteeId: menteeId,
  );

  if (alreadyRated) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Bạn đã đánh giá lịch hẹn này rồi.",
          ),
        ),
      );
    }

    return;
  }

  // =====================================================
  // CREATE APPOINTMENT RATING MODEL
  // =====================================================

  final ratingModel =
      AppointmentRatingModel(
    id: "",
    mentorId: appointment.mentorId,
    menteeId: appointment.menteeId,
    appointmentId: appointment.id,
    mentorName: appointment.mentorName,
    menteeName: appointment.menteeName,
    rating: rating.toDouble(),
    comment: comment,
    createdAt: DateTime.now(),
  );

  // =====================================================
  // SAVE RATING
  // =====================================================

  await _ratingService.createRating(
    ratingModel,
  );

  // =====================================================
  // UPDATE APPOINTMENT RATED = TRUE
  // =====================================================

  await FirebaseFirestore.instance
      .collection("appointments")
      .doc(appointment.id)
      .update({
    "rated": true,
  });

  // =====================================================
  // SUCCESS
  // =====================================================

  if (context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Cảm ơn bạn đã đánh giá Mentor!",
        ),
      ),
    );
  }
} catch (e) {
  // =====================================================
  // ERROR
  // =====================================================

  if (context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "Không thể đánh giá: $e",
        ),
      ),
    );
  }
}


}
}
