import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/session_model.dart';

class SessionParticipantActions extends StatelessWidget {
  final SessionModel session;

  final bool isJoined;
  final bool loading;

  final VoidCallback? onJoin;
  final VoidCallback? onLeave;

  const SessionParticipantActions({
    super.key,
    required this.session,
    required this.isJoined,
    required this.loading,
    this.onJoin,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // SESSION ĐÃ HOÀN THÀNH HOẶC ĐÃ HỦY
    // Không hiển thị nút Leave / Join
    // =========================================================
    if (session.status == 'completed' ||
        session.status == 'cancelled') {
      return _buildFinalStatus();
    }

    // =========================================================
    // SESSION ĐANG CHẠY
    // Không cho Join / Leave
    // =========================================================
    if (session.status == 'running') {
      if (isJoined) {
        return _buildRunningStatus();
      }

      return const SizedBox.shrink();
    }

    // =========================================================
    // SESSION ĐÃ ĐẦY
    // Nếu đã tham gia thì vẫn hiển thị trạng thái Joined
    // Nếu chưa tham gia thì không cho Join
    // =========================================================
    if (session.status == 'full' &&
        !isJoined) {
      return _buildFullStatus();
    }

    // =========================================================
    // MENTEE ĐÃ THAM GIA
    // Hiển thị nút Leave
    // =========================================================
    if (isJoined) {
      return _buildLeaveButton();
    }

    // =========================================================
    // SESSION ĐANG OPEN
    // Hiển thị nút Join
    // =========================================================
    if (session.status == 'open') {
      return _buildJoinButton();
    }

    return const SizedBox.shrink();
  }

  // =========================================================
  // JOIN BUTTON
  // =========================================================

  Widget _buildJoinButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: loading ? null : onJoin,
          icon: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.group_add_outlined,
                ),
          label: Text(
            loading
                ? 'Joining...'
                : 'Join Session',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.deepGreen,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(
              vertical: 14,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // LEAVE BUTTON
  // =========================================================

  Widget _buildLeaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed:
              loading ? null : onLeave,
          icon: const Icon(
            Icons.logout_outlined,
          ),
          label: Text(
            loading
                ? 'Processing...'
                : 'Leave Session',
          ),
          style:
              OutlinedButton.styleFrom(
            foregroundColor:
                Colors.red,
            side: const BorderSide(
              color: Colors.red,
            ),
            padding:
                const EdgeInsets.symmetric(
              vertical: 14,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SESSION FULL
  // =========================================================

  Widget _buildFullStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.orange
              .withOpacity(0.1),
          borderRadius:
              BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange
                .withOpacity(0.4),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_outlined,
              color: Colors.orange,
            ),
            SizedBox(width: 8),
            Text(
              'Session is full',
              style: TextStyle(
                color: Colors.orange,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // RUNNING STATUS
  // =========================================================

  Widget _buildRunningStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.deepGreen
              .withOpacity(0.1),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline,
              color: AppColors.deepGreen,
            ),
            SizedBox(width: 8),
            Text(
              'Session is currently running',
              style: TextStyle(
                color: AppColors.deepGreen,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // COMPLETED / CANCELLED
  // =========================================================

  Widget _buildFinalStatus() {
    final bool isCompleted =
        session.status == 'completed';

    final Color statusColor =
        isCompleted
            ? AppColors.completed
            : AppColors.cancelled;

    final IconData icon =
        isCompleted
            ? Icons.check_circle_outline
            : Icons.cancel_outlined;

    final String text =
        isCompleted
            ? 'Session completed'
            : 'Session cancelled';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: statusColor
              .withOpacity(0.1),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: statusColor,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: statusColor,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}