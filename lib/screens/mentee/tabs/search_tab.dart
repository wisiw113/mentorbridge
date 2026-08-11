
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/models/session_model.dart';

import 'package:flutter_application_1/services/appointment_rating_service.dart';

import 'package:flutter_application_1/widgets/mentor/mentor_card.dart';
import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_card.dart';

import 'package:flutter_application_1/screens/mentee/screens/mentor_profile_screen.dart';
import 'package:flutter_application_1/screens/mentee/screens/mentee_session_detail_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController =
      TextEditingController();

  final AppointmentRatingService _ratingService =
      AppointmentRatingService();

  late TabController _tabController;

  String keyword = "";

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // =====================================================
        // APP BAR
        // =====================================================

        appBar: AppBar(
          title: const Text(
            "Tìm kiếm",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.deepGreen,
          elevation: 0,

          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.deepGreen,
            unselectedLabelColor: AppColors.gray,
            indicatorColor: AppColors.mintGreen,
            tabs: const [
              Tab(
                icon: Icon(Icons.person_search),
                text: "Tìm Mentor",
              ),
              Tab(
                icon: Icon(Icons.groups),
                text: "Tìm Session",
              ),
            ],
          ),
        ),

        // =====================================================
        // BODY
        // =====================================================

        body: Column(
          children: [
            // =================================================
            // SEARCH BAR
            // =================================================

            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    keyword =
                        value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText:
                      _tabController.index == 0
                          ? "Nhập tên mentor..."
                          : "Nhập tên session...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.iconSecondary,
                  ),
                  suffixIcon:
                      keyword.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController
                                    .clear();

                                setState(() {
                                  keyword = "";
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                                color:
                                    AppColors.iconSecondary,
                              ),
                            )
                          : null,
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.mintGreen,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            // =================================================
            // TAB CONTENT
            // =================================================

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMentorList(),
                  _buildSessionList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // MENTOR LIST
  // =========================================================

  Widget _buildMentorList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .where(
            "role",
            isEqualTo: "mentor",
          )
          .snapshots(),
      builder: (context, snapshot) {
        // ===================================================
        // LOADING
        // ===================================================

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.mintGreen,
            ),
          );
        }

        // ===================================================
        // ERROR
        // ===================================================

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Lỗi: ${snapshot.error}",
              style: const TextStyle(
                color: AppColors.error,
              ),
            ),
          );
        }

        // ===================================================
        // EMPTY
        // ===================================================

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "Không có mentor nào",
              style: TextStyle(
                color: AppColors.gray,
              ),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        // ===================================================
        // FILTER
        // ===================================================

        final filtered = docs.where((doc) {
          final data =
              doc.data()
                  as Map<String, dynamic>;

          final name =
              (data["name"] ?? "")
                  .toString()
                  .toLowerCase();

          final email =
              (data["email"] ?? "")
                  .toString()
                  .toLowerCase();

          return name.contains(keyword) ||
              email.contains(keyword);
        }).toList();

        // ===================================================
        // NO RESULT
        // ===================================================

        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              "Không tìm thấy mentor",
              style: TextStyle(
                color: AppColors.gray,
              ),
            ),
          );
        }

        // ===================================================
        // LIST
        // ===================================================

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          itemCount: filtered.length,
          itemBuilder: (
            context,
            index,
          ) {
            final doc = filtered[index];

            final data =
                doc.data()
                    as Map<String, dynamic>;

            final mentorId = doc.id;

            return FutureBuilder<
                Map<String, dynamic>>(
              future: _ratingService
                  .getMentorRatingSummary(
                mentorId,
              ),
              builder: (
                context,
                ratingSnapshot,
              ) {
                double rating = 0.0;
                int reviewCount = 0;

                if (ratingSnapshot.hasData) {
                  final result =
                      ratingSnapshot.data!;

                  rating =
                      (result[
                                  "averageRating"] ??
                              0.0)
                          .toDouble();

                  reviewCount =
                      (result[
                                  "reviewCount"] ??
                              0) as int;
                }

                return MentorCard(
                  name:
                      data["name"] ??
                          "No name",
                  email:
                      data["email"] ??
                          "",
                  avatarUrl:
                      data["photoURL"]
                          ?.toString(),
                  rating: rating,
                  reviewCount:
                      reviewCount,

                  // ===============================
                  // OPEN MENTOR PROFILE
                  // ===============================

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MentorProfileScreen(
                          mentorId: mentorId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // =========================================================
  // SESSION LIST
  // =========================================================

  Widget _buildSessionList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("sessions")
          .where(
            "status",
            isEqualTo: "open",
          )
          .snapshots(),
      builder: (context, snapshot) {
        // ===================================================
        // LOADING
        // ===================================================

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.mintGreen,
            ),
          );
        }

        // ===================================================
        // ERROR
        // ===================================================

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Lỗi: ${snapshot.error}",
              style: const TextStyle(
                color: AppColors.error,
              ),
            ),
          );
        }

        // ===================================================
        // EMPTY
        // ===================================================

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "Không có session nào",
              style: TextStyle(
                color: AppColors.gray,
              ),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        // ===================================================
        // FILTER
        // ===================================================

        final filtered = docs.where((doc) {
          final data =
              doc.data()
                  as Map<String, dynamic>;

          final title =
              (data["title"] ?? "")
                  .toString()
                  .toLowerCase();

          final description =
              (data["description"] ?? "")
                  .toString()
                  .toLowerCase();

          final mentorName =
              (data["mentorName"] ?? "")
                  .toString()
                  .toLowerCase();

          return title.contains(keyword) ||
              description.contains(keyword) ||
              mentorName.contains(keyword);
        }).toList();

        // ===================================================
        // NO RESULT
        // ===================================================

        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              "Không tìm thấy session",
              style: TextStyle(
                color: AppColors.gray,
              ),
            ),
          );
        }

        // ===================================================
        // SESSION LIST
        // ===================================================

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 4,
          ),
          itemCount: filtered.length,
          itemBuilder: (
            context,
            index,
          ) {
            final doc = filtered[index];

            final data =
                doc.data()
                    as Map<String, dynamic>;

            final session =
                SessionModel.fromMap(
              doc.id,
              data,
            );

            return SessionCard(
              title: session.title,
              description:
                  session.description,
              date: session.date,
              startTime:
                  session.startTime,
              endTime:
                  session.endTime,
              bookedSlots:
                  session.bookedSlots,
              maxSlots:
                  session.maxSlots,
              status:
                  session.status,

              // ===============================
              // OPEN SESSION DETAIL
              // ===============================

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MenteeSessionDetailScreen(
                      session: session,
                    ),
                  ),
                );
              },

              // ===============================
              // JOIN
              // ===============================

              onJoin: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MenteeSessionDetailScreen(
                      session: session,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

