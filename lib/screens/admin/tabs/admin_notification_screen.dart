
import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';
import '/../services/notification_service.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({
    super.key,
  });

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState
    extends State<AdminNotificationScreen>
    with SingleTickerProviderStateMixin {
  // =========================================================
  // SERVICE
  // =========================================================

  final NotificationService _notificationService =
      NotificationService();

  // =========================================================
  // CONTROLLERS
  // =========================================================

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _messageController =
      TextEditingController();

  late TabController _tabController;

  // =========================================================
  // STATE
  // =========================================================

  String _selectedTarget = 'all';

  bool _isSending = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  // =========================================================
  // SEND NOTIFICATION
  // =========================================================

  Future<void> _sendNotification() async {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    // ---------------------------------------------------------
    // VALIDATE
    // ---------------------------------------------------------

    if (title.isEmpty) {
      _showMessage(
        'Vui lòng nhập tiêu đề thông báo.',
        isError: true,
      );
      return;
    }

    if (message.isEmpty) {
      _showMessage(
        'Vui lòng nhập nội dung thông báo.',
        isError: true,
      );
      return;
    }

    // ---------------------------------------------------------
    // CONFIRM
    // ---------------------------------------------------------

    final shouldSend = await _showConfirmDialog();

    if (!shouldSend) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isSending = true;
    });

    // ---------------------------------------------------------
    // SEND
    // ---------------------------------------------------------

    try {
      await _notificationService.sendAdminNotification(
        target: _selectedTarget,
        title: title,
        message: message,
      );

      if (!mounted) return;

      // -------------------------------------------------------
      // CLEAR FORM
      // -------------------------------------------------------

      _titleController.clear();
      _messageController.clear();

      setState(() {
        _selectedTarget = 'all';
      });

      _showMessage(
        'Đã gửi thông báo thành công.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Không thể gửi thông báo. Vui lòng thử lại.',
        isError: true,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isSending = false;
      });
    }
  }

  // =========================================================
  // CONFIRM DIALOG
  // =========================================================

  Future<bool> _showConfirmDialog() async {
    final targetLabel = _getTargetLabel();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.notifications_active_rounded,
                color: AppColors.deepGreen,
              ),
              SizedBox(width: 10),
              Text(
                'Xác nhận gửi',
              ),
            ],
          ),
          content: Text(
            'Bạn có chắc muốn gửi thông báo này đến '
            '$targetLabel không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Hủy',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepGreen,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Gửi',
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError
            ? AppColors.error
            : AppColors.deepGreen,
      ),
    );
  }

  // =========================================================
  // TARGET LABEL
  // =========================================================

  String _getTargetLabel() {
    switch (_selectedTarget) {
      case 'mentor':
        return 'Mentor';

      case 'mentee':
        return 'Mentee';

      case 'all':
      default:
        return 'tất cả người dùng';
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBF8),
      appBar: AppBar(
        backgroundColor: AppColors.softMint,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepGreen,
          unselectedLabelColor: Colors.black45,
          indicatorColor: AppColors.deepGreen,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.send_rounded,
              ),
              text: 'Gửi thông báo',
            ),
            Tab(
              icon: Icon(
                Icons.history_rounded,
              ),
              text: 'Lịch sử',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSendTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  // =========================================================
  // SEND TAB
  // =========================================================

  Widget _buildSendTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildTargetSection(),

          const SizedBox(height: 24),

          _buildTitleField(),

          const SizedBox(height: 20),

          _buildMessageField(),

          const SizedBox(height: 24),

          _buildPreview(),

          const SizedBox(height: 28),

          _buildSendButton(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =========================================================
  // TARGET SECTION
  // =========================================================

  Widget _buildTargetSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Đối tượng nhận',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildTargetCard(
                value: 'all',
                icon: Icons.groups_rounded,
                title: 'Tất cả',
                subtitle: 'Mọi người',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildTargetCard(
                value: 'mentor',
                icon: Icons.school_rounded,
                title: 'Mentor',
                subtitle: 'Mentor',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildTargetCard(
                value: 'mentee',
                icon: Icons.person_rounded,
                title: 'Mentee',
                subtitle: 'Mentee',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // TARGET CARD
  // =========================================================

  Widget _buildTargetCard({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected =
        _selectedTarget == value;

    return GestureDetector(
      onTap: _isSending
          ? null
          : () {
              setState(() {
                _selectedTarget = value;
              });
            },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.softMint
              : Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.deepGreen
                : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.deepGreen
                  : Colors.grey,
              size: 28,
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.deepGreen
                    : Colors.black87,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // TITLE FIELD
  // =========================================================

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiêu đề',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: _titleController,
          enabled: !_isSending,
          maxLength: 100,
          onChanged: (_) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText:
                'Nhập tiêu đề thông báo...',
            prefixIcon: const Icon(
              Icons.title_rounded,
            ),
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.deepGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // MESSAGE FIELD
  // =========================================================

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Nội dung',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: _messageController,
          enabled: !_isSending,
          minLines: 5,
          maxLines: 8,
          maxLength: 1000,
          onChanged: (_) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText:
                'Nhập nội dung thông báo...',
            alignLabelWithHint: true,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(
                bottom: 80,
              ),
              child: Icon(
                Icons.message_rounded,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.deepGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PREVIEW
  // =========================================================

  Widget _buildPreview() {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.visibility_rounded,
                size: 20,
                color: AppColors.deepGreen,
              ),
              SizedBox(width: 8),
              Text(
                'Xem trước',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.softMint,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: AppColors.deepGreen,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty
                          ? 'Tiêu đề thông báo'
                          : title,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      message.isEmpty
                          ? 'Nội dung thông báo sẽ hiển thị ở đây.'
                          : message,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Đến: ${_getTargetLabel()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.deepGreen,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SEND BUTTON
  // =========================================================

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed:
            _isSending ? null : _sendNotification,
        icon: _isSending
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
                Icons.send_rounded,
              ),
        label: Text(
          _isSending
              ? 'Đang gửi...'
              : 'Gửi thông báo',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.deepGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              AppColors.deepGreen
                  .withOpacity(0.6),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // =========================================================
  // HISTORY TAB
  // =========================================================

  Widget _buildHistoryTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 70,
              color: AppColors.deepGreen
                  .withOpacity(0.5),
            ),

            const SizedBox(height: 16),

            const Text(
              'Lịch sử thông báo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Lịch sử thông báo có thể bổ sung sau.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

