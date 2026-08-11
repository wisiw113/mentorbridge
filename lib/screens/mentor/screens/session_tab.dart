import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/session_model.dart';
import 'package:flutter_application_1/services/session_service.dart';

import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_card.dart';
import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_search_bar.dart';
import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_filter_bar.dart';
import 'package:flutter_application_1/widgets/session/mentor_session_activity/session_empty_state.dart';

import 'package:flutter_application_1/screens/mentor/screens/create_session_screen.dart';
import 'package:flutter_application_1/screens/mentor/screens/session_detail_screen.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';

class SessionTab extends StatefulWidget {
  const SessionTab({
    super.key,
  });

  @override
  State<SessionTab> createState() => _SessionTabState();
}

class _SessionTabState extends State<SessionTab> {
  final SessionService _sessionService = SessionService();

  final TextEditingController _searchController =
      TextEditingController();

  // =========================================================
  // SEARCH
  // =========================================================

  String _searchText = '';

  // =========================================================
  // FILTER
  // =========================================================

  String _selectedFilter = 'all';

  // =========================================================
  // STREAM
  // =========================================================

  Stream<List<SessionModel>>? _sessionsStream;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _sessionsStream = _sessionService.getMentorSessions(
        user.uid,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // FILTER SESSION
  // =========================================================

  List<SessionModel> _filterSessions(
    List<SessionModel> sessions,
  ) {
    final search = _searchText.trim().toLowerCase();

    return sessions.where((session) {
      // =====================================================
      // SEARCH
      // =====================================================

      final matchSearch =
          search.isEmpty ||
          session.title.toLowerCase().contains(search) ||
          session.description.toLowerCase().contains(search);

      // =====================================================
      // FILTER STATUS
      // =====================================================

      final matchStatus =
          _selectedFilter == 'all' ||
          session.status.toLowerCase() ==
              _selectedFilter.toLowerCase();

      return matchSearch && matchStatus;
    }).toList();
  }

  // =========================================================
  // SEARCH CHANGED
  // =========================================================

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value.trim().toLowerCase();
    });
  }

  // =========================================================
  // FILTER CHANGED
  // =========================================================

  void _onFilterChanged(String value) {
    setState(() {
      _selectedFilter = value;
    });
  }

  // =========================================================
  // CREATE SESSION
  // =========================================================

  Future<void> _createSession() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateSessionScreen(),
      ),
    );
  }

  // =========================================================
  // OPEN SESSION DETAIL
  // =========================================================

  Future<void> _openSessionDetail(
    SessionModel session,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SessionDetailScreen(
          session: session,
        ),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // =========================================================
    // NOT LOGIN
    // =========================================================

    if (user == null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: const Center(
          child: Text(
            'Chưa đăng nhập',
          ),
        ),
      );
    }

    // =========================================================
    // STREAM
    // =========================================================

    final stream = _sessionsStream;

    if (stream == null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: const Center(
          child: Text(
            'Không thể tải Session.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,

      // =======================================================
      // BODY
      // =======================================================

      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),

        child: Stack(
          children: [
            // =================================================
            // SESSION CONTENT
            // =================================================

            Positioned.fill(
              child: StreamBuilder<List<SessionModel>>(
                stream: stream,
                builder: (
                  context,
                  snapshot,
                ) {
                  // ===========================================
                  // LOADING
                  // ===========================================

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mintGreen,
                      ),
                    );
                  }

                  // ===========================================
                  // ERROR
                  // ===========================================

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

                  // ===========================================
                  // ALL SESSIONS
                  // ===========================================

                  final sessions = snapshot.data ?? [];

                  // ===========================================
                  // FILTERED SESSIONS
                  // ===========================================

                  final filteredSessions =
                      _filterSessions(sessions);

                  return Column(
                    children: [
                      // =======================================
                      // SEARCH BAR
                      // =======================================

                      SessionSearchBar(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                      ),

                      // =======================================
                      // FILTER BAR
                      // =======================================

                      SessionFilterBar(
                        selectedStatus: _selectedFilter,
                        onChanged: _onFilterChanged,
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      // =======================================
                      // SESSION LIST
                      // =======================================

                      Expanded(
                        child: _buildSessionContent(
                          sessions: sessions,
                          filteredSessions: filteredSessions,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // =================================================
            // CREATE SESSION BUTTON
            //
            // ĐẶT BÊN TRÁI + CAO HƠN NAVBAR
            // =================================================

            Positioned(
              left: 20,
              bottom: 90,
              child: FloatingActionButton.extended(
                heroTag: 'create_session_button',
                onPressed: _createSession,
                backgroundColor: AppColors.mintGreen,
                foregroundColor: AppColors.white,
                elevation: 5,
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Tạo Session',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SESSION CONTENT
  // =========================================================

  Widget _buildSessionContent({
    required List<SessionModel> sessions,
    required List<SessionModel> filteredSessions,
  }) {
    // =========================================================
    // NO SESSION AT ALL
    // =========================================================

    if (sessions.isEmpty) {
      return const SessionEmptyState();
    }

    // =========================================================
    // SEARCH / FILTER HAS NO RESULT
    // =========================================================

    if (filteredSessions.isEmpty) {
      return _buildNoSearchResult();
    }

    // =========================================================
    // SESSION LIST
    // =========================================================

    return ListView.builder(
      key: const PageStorageKey(
        'mentor_session_list',
      ),
      padding: const EdgeInsets.only(
        top: 0,
        left: 12,
        right: 12,

        // Chừa khoảng trống phía dưới
        // để không bị navbar / nút Create đè
        bottom: 180,
      ),
      itemCount: filteredSessions.length,
      itemBuilder: (
        context,
        index,
      ) {
        final session = filteredSessions[index];

        return SessionCard(
          title: session.title,
          description: session.description,
          date: session.date,
          startTime: session.startTime,
          endTime: session.endTime,
          bookedSlots: session.bookedSlots,
          maxSlots: session.maxSlots,
          status: session.status,
          onTap: () {
            _openSessionDetail(session);
          },
        );
      },
    );
  }

  // =========================================================
  // NO SEARCH RESULT
  // =========================================================

  Widget _buildNoSearchResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =================================================
            // ICON
            // =================================================

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.65),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 50,
                color: AppColors.gray,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            // =================================================
            // TITLE
            // =================================================

            const Text(
              'Không tìm thấy Session',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.titleText,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // =================================================
            // DESCRIPTION
            // =================================================

            Text(
              _searchText.isNotEmpty
                  ? 'Không có Session nào phù hợp với "$_searchText".'
                  : 'Không có Session nào phù hợp với bộ lọc hiện tại.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.gray,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // RESET
            // =================================================

            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();

                setState(() {
                  _searchText = '';
                  _selectedFilter = 'all';
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.deepGreen,
                side: const BorderSide(
                  color: AppColors.mintGreen,
                ),
              ),
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Xóa tìm kiếm và bộ lọc',
              ),
            ),
          ],
        ),
      ),
    );
  }
}