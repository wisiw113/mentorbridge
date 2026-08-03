
import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class ChatAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String mentorName;

  const ChatAppBar({
    super.key,
    required this.mentorName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,

      backgroundColor: AppColors.white,

      foregroundColor: AppColors.darkGray,

      centerTitle: false,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(18),
        ),
        side: BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),

      title: Row(
        children: [
          // =================================================
          // AVATAR
          // =================================================

          CircleAvatar(
            radius: 19,

            backgroundColor:
                AppColors.softMint,

            child: Text(
              _getInitial(mentorName),

              style: const TextStyle(
                color: AppColors.deepGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          // =================================================
          // MENTOR NAME
          // =================================================

          Expanded(
            child: Text(
              mentorName.trim().isEmpty
                  ? 'Mentor'
                  : mentorName,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GET INITIAL
  // =========================================================

  String _getInitial(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    return trimmedName
        .substring(0, 1)
        .toUpperCase();
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}

