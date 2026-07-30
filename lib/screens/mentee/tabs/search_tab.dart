import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/models/session_model.dart';

import 'package:flutter_application_1/services/rating_service.dart';

import 'package:flutter_application_1/widgets/mentor/mentor_card.dart';
import 'package:flutter_application_1/widgets/session/session_card.dart';

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

  final RatingService _ratingService =
      RatingService();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tìm kiếm"),
        bottom: TabBar(
          controller: _tabController,
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
      body: Column(
        children: [
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
                prefixIcon:
                    const Icon(Icons.search),
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
                            ),
                          )
                        : null,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),

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
    );
  }

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
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child:
                CircularProgressIndicator(),
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
            snapshot.data!.docs.isEmpty) {
          return const Center(
            child:
                Text("Không có mentor nào"),
          );
        }

        final docs = snapshot.data!.docs;

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

        if (filtered.isEmpty) {
          return const Center(
            child:
                Text("Không tìm thấy mentor"),
          );
        }

        return ListView.builder(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          itemCount: filtered.length,
          itemBuilder:
              (context, index) {
            final doc =
                filtered[index];

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
              builder:
                  (context, ratingSnapshot) {
                double rating = 0.0;
                int reviewCount = 0;

                if (ratingSnapshot.hasData) {
                  final result =
                      ratingSnapshot.data!;

                  rating =
                      (result["averageRating"] ??
                              0.0)
                          .toDouble();

                  reviewCount =
                      (result["reviewCount"] ??
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MentorProfileScreen(
                          mentorId:
                              mentorId,
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
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child:
                CircularProgressIndicator(),
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
            snapshot.data!.docs.isEmpty) {
          return const Center(
            child:
                Text("Không có session nào"),
          );
        }

        final docs = snapshot.data!.docs;

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

        if (filtered.isEmpty) {
          return const Center(
            child:
                Text("Không tìm thấy session"),
          );
        }

        return ListView.builder(
          padding:
              const EdgeInsets.symmetric(
            vertical: 8,
          ),
          itemCount: filtered.length,
          itemBuilder:
              (context, index) {
            final doc =
                filtered[index];

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