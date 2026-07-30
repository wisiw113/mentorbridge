import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';

import 'package:flutter_application_1/widgets/session/session_card.dart';
import 'package:flutter_application_1/widgets/session/session_search_bar.dart';
import 'package:flutter_application_1/widgets/session/session_filter_bar.dart';
import 'package:flutter_application_1/widgets/session/session_empty_state.dart';

import 'package:flutter_application_1/screens/mentor/screens/create_session_screen.dart';
import 'package:flutter_application_1/screens/mentor/screens/session_detail_screen.dart';

class SessionTab extends StatefulWidget {
  const SessionTab({super.key});

  @override
  State<SessionTab> createState() => _SessionTabState();
}

class _SessionTabState extends State<SessionTab> {
  final SessionService _sessionService = SessionService();

  final TextEditingController _searchController =
      TextEditingController();

  String _searchText = '';
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Chưa đăng nhập'),
      );
    }

    return Stack(
      children: [
        StreamBuilder<List<SessionModel>>(
          stream: _sessionService.getMentorSessions(user.uid),
          builder: (context, snapshot) {
            // =========================
            // LOADING
            // =========================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // =========================
            // ERROR
            // =========================

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Không thể tải Session.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final sessions = snapshot.data ?? [];

            // =========================
            // FILTER + SEARCH
            // =========================

            final filteredSessions =
                sessions.where((session) {
              final matchSearch = session.title
                  .toLowerCase()
                  .contains(
                    _searchText.toLowerCase(),
                  );

              final matchFilter =
                  _selectedFilter == 'All'
                      ? true
                      : session.status ==
                          _selectedFilter;

              return matchSearch && matchFilter;
            }).toList();

            return Column(
              children: [
                SessionSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),

                SessionFilterBar(
  selectedStatus: _selectedFilter,
  onChanged: (value) {
    setState(() {
      _selectedFilter = value;
    });
  },
),

                Expanded(
                                    child: filteredSessions.isEmpty
                      ? const SessionEmptyState()
                      : ListView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(
                            0,
                            8,
                            0,
                            100,
                          ),
                          itemCount:
                              filteredSessions.length,
                          itemBuilder:
                              (context, index) {
                            final session =
                                filteredSessions[
                                    index];

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
                                        SessionDetailScreen(
                                      session:
                                          session,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CreateSessionScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text(
              'Create Session',
            ),
          ),
        ),
      ],
    );
  }
}