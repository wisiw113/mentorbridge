
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ChatListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChatListAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,

      backgroundColor: AppColors.white,

      foregroundColor: AppColors.deepGreen,

      centerTitle: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(18),
        ),
        side: BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),

      title: const Text(
        'Tin nhắn',
        style: TextStyle(
          color: AppColors.deepGreen,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}

