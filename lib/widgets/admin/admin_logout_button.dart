
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../common/confirm_dialog.dart';

class AdminLogoutButton extends StatelessWidget {
  const AdminLogoutButton({
    super.key,
  });

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
    );

    if (!confirmed) return;

    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Logout',
      onPressed: () => _logout(context),
      icon: const Icon(
        Icons.logout,
        color: AppColors.white,
      ),
    );
  }
}

