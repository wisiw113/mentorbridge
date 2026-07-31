
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/appointment_rating_service.dart';

import '../../../widgets/mentor/mentor_booking_button.dart';
import '../../../widgets/mentor/mentor_header.dart';
import '../../../widgets/mentor/mentor_rating_card.dart';

import 'mentor_booking_screen.dart';

class MentorProfileScreen extends StatelessWidget {
  final String mentorId;

  const MentorProfileScreen({
    super.key,
    required this.mentorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: const Text("Thông tin Mentor"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(mentorId)
            .snapshots(),

        builder: (context, userSnapshot) {
          // =========================
          // LOADING USER
          // =========================

          if (userSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =========================
          // ERROR USER
          // =========================

          if (userSnapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi tải thông tin Mentor: "
                "${userSnapshot.error}",
              ),
            );
          }

          // =========================
          // USER NOT FOUND
          // =========================

          if (!userSnapshot.hasData ||
              !userSnapshot.data!.exists) {
            return const Center(
              child: Text(
                "Không tìm thấy Mentor",
              ),
            );
          }

          final data =
              userSnapshot.data!.data() ?? {};

          // =========================
          // BASIC INFO
          // =========================

          final String name =
              data["name"]?.toString() ?? "Mentor";

          final String email =
              data["email"]?.toString() ?? "";

          final String? avatarUrl =
              data["photoURL"]?.toString();

          // =========================
          // RATING
          // =========================

          return FutureBuilder<Map<String, dynamic>>(
            future: AppointmentRatingService()
                .getMentorRatingSummary(mentorId),

            builder: (
              context,
              ratingSnapshot,
            ) {
              // =========================
              // LOADING RATING
              // =========================

              if (ratingSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // =========================
              // ERROR RATING
              // =========================

              if (ratingSnapshot.hasError) {
                return Center(
                  child: Text(
                    "Lỗi tải đánh giá Mentor: "
                    "${ratingSnapshot.error}",
                  ),
                );
              }

              double rating = 0.0;
              int totalRating = 0;

              if (ratingSnapshot.hasData) {
                final result =
                    ratingSnapshot.data!;

                final average =
                    result["averageRating"];

                final count =
                    result["reviewCount"];

                if (average is num) {
                  rating =
                      average.toDouble();
                }

                if (count is num) {
                  totalRating =
                      count.toInt();
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 30,
                ),

                child: Column(
                  children: [
                    // =========================
                    // MENTOR HEADER
                    // =========================

                    MentorHeader(
                      name: name,
                      email: email,
                      avatarUrl: avatarUrl,
                      rating: rating,
                      totalRating: totalRating,
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // RATING CARD
                    // =========================

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: MentorRating(
                        rating: rating,
                        totalRating: totalRating,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // =========================
                    // BOOKING BUTTON
                    // =========================

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: MentorBookingButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MentorBookingScreen(
                                mentorId: mentorId,
                                mentorName: name,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

