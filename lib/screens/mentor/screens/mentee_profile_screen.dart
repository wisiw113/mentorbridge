import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../services/user_profile_service.dart';
import '../../chat/chat_screen.dart';

class MenteeProfileScreen extends StatefulWidget {
  final String menteeId;

  // Có thể truyền sẵn tên từ AppointmentModel
  // để hiển thị ngay trong lúc chờ Firestore.
  final String? menteeName;

  const MenteeProfileScreen({
    super.key,
    required this.menteeId,
    this.menteeName,
  });

  @override
  State<MenteeProfileScreen> createState() =>
      _MenteeProfileScreenState();
}

class _MenteeProfileScreenState
    extends State<MenteeProfileScreen> {
  // =========================================================
  // SERVICE
  // =========================================================

  final UserProfileService _userProfileService =
      UserProfileService();

  // =========================================================
  // STATE
  // =========================================================

  bool _isLoading = true;

  bool _isOpeningChat = false;

  Map<String, dynamic>? _userData;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    _loadMenteeProfile();
  }

  // =========================================================
  // LOAD MENTEE PROFILE
  // =========================================================

  Future<void> _loadMenteeProfile() async {
    try {
      final data =
          await _userProfileService.getUserProfile(
        widget.menteeId,
      );

      if (!mounted) return;

      setState(() {
        _userData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(
        'Load mentee profile error: $e',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // =========================================================
  // GET NAME
  // =========================================================

  String get _menteeName {
    final name =
        _userData?['name']?.toString().trim() ?? '';

    if (name.isNotEmpty) {
      return name;
    }

    final displayName =
        _userData?['displayName']
                ?.toString()
                .trim() ??
            '';

    if (displayName.isNotEmpty) {
      return displayName;
    }

    if (widget.menteeName != null &&
        widget.menteeName!.trim().isNotEmpty) {
      return widget.menteeName!.trim();
    }

    return 'Mentee';
  }

  // =========================================================
  // GET EMAIL
  // =========================================================

  String get _email {
    final email =
        _userData?['email']?.toString().trim() ?? '';

    if (email.isEmpty) {
      return 'Email chưa cập nhật';
    }

    return email;
  }

  // =========================================================
  // GET GENDER
  // =========================================================

  String get _gender {
    final gender =
        _userData?['gender']?.toString().trim() ?? '';

    if (gender.isEmpty) {
      return 'Chưa cập nhật';
    }

    return gender;
  }

  // =========================================================
  // GET BIRTH YEAR
  // =========================================================

  String get _birthYear {
    final birthYear =
        _userData?['birthYear'];

    if (birthYear == null) {
      return 'Chưa cập nhật';
    }

    return birthYear.toString();
  }

  // =========================================================
  // GET BIO
  // =========================================================

  String get _bio {
    final bio =
        _userData?['bio']?.toString().trim() ?? '';

    if (bio.isEmpty) {
      return 'Mentee chưa cập nhật giới thiệu.';
    }

    return bio;
  }

  // =========================================================
  // GET PHOTO URL
  // =========================================================

  String? get _photoURL {
    final photoURL =
        _userData?['photoURL']
            ?.toString()
            .trim();

    if (photoURL == null ||
        photoURL.isEmpty) {
      return null;
    }

    return photoURL;
  }

  // =========================================================
  // OPEN CHAT
  // =========================================================

  Future<void> _openChat() async {
    if (_isOpeningChat) {
      return;
    }

    setState(() {
      _isOpeningChat = true;
    });

    try {
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            // =================================================
            // LƯU Ý
            // =================================================
            //
            // ChatScreen hiện tại của bạn đang được thiết kế
            // theo hướng:
            //
            // Mentee -> Mentor
            //
            // nên phần này sẽ cần sửa ChatScreen để hỗ trợ:
            //
            // Mentor -> Mentee
            //
            // Tạm thời truyền Mentee như "đối tượng chat".
            //
            mentorId: widget.menteeId,
            mentorName: _menteeName,
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'Open chat error: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Không thể mở cuộc trò chuyện: $e',
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isOpeningChat = false;
      });
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightMint.withOpacity(0.15),

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        title: const Text(
          'Mentee Profile',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.mintGreen,
              ),
            )
          : _buildProfile(),
    );
  }

  // =========================================================
  // PROFILE
  // =========================================================

  Widget _buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // ===================================================
          // PROFILE HEADER
          // ===================================================

          _buildProfileHeader(),

          const SizedBox(height: 20),

          // ===================================================
          // BASIC INFORMATION
          // ===================================================

          _buildInfoCard(),

          const SizedBox(height: 16),

          // ===================================================
          // BIO
          // ===================================================

          _buildBioCard(),

          const SizedBox(height: 24),

          // ===================================================
          // CHAT BUTTON
          // ===================================================

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed:
                  _isOpeningChat
                      ? null
                      : _openChat,
              icon: _isOpeningChat
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.chat_bubble_outline,
                    ),
              label: Text(
                _isOpeningChat
                    ? 'Đang mở chat...'
                    : 'Nhắn tin với Mentee',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.mintGreen,
                foregroundColor:
                    Colors.white,
                disabledBackgroundColor:
                    Colors.grey.shade300,
                disabledForegroundColor:
                    Colors.grey.shade600,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PROFILE HEADER
  // =========================================================

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // =================================================
          // AVATAR
          // =================================================

          CircleAvatar(
            radius: 48,
            backgroundColor:
                AppColors.lightMint,
            backgroundImage:
                _photoURL != null
                    ? NetworkImage(
                        _photoURL!,
                      )
                    : null,
            child: _photoURL == null
                ? const Icon(
                    Icons.person_outline,
                    size: 48,
                    color:
                        AppColors.deepGreen,
                  )
                : null,
          ),

          const SizedBox(height: 16),

          // =================================================
          // NAME
          // =================================================

          Text(
            _menteeName,
            textAlign: TextAlign.center,
            style:
                const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // =================================================
          // EMAIL
          // =================================================

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                size: 16,
                color:
                    Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _email,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFORMATION CARD
  // =========================================================

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin cá nhân',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoRow(
            icon:
                Icons.person_outline,
            label: 'Giới tính',
            value: _gender,
          ),

          const Divider(height: 24),

          _buildInfoRow(
            icon:
                Icons.cake_outlined,
            label: 'Năm sinh',
            value: _birthYear,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BIO CARD
  // =========================================================

  Widget _buildBioCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Giới thiệu',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            _bio,
            style: TextStyle(
              fontSize: 14,
              color:
                  Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFO ROW
  // =========================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color:
                AppColors.lightMint,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color:
                AppColors.deepGreen,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}