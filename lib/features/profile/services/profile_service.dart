import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'package:zenith_habit_tracker/features/common/widgets/dialog_box.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';

class ProfileService {
  final BuildContext context;
  final UserProvider user;

  ProfileService({required this.context, required this.user});

  // ── Avatar ────────────────────────────────────────────────────────────────

  void onAvatarSelected(String emoji, VoidCallback onDone) async {
    user.setAvatar(emoji);
    onDone();
  }

  // ── Username ──────────────────────────────────────────────────────────────

  Future<void> changeUsername() async {
    final controller = TextEditingController(text: user.name);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DialogBox(
        title: 'Change Username',
        confirmText: 'Save',
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter new username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        onConfirm: () async {
          final value = controller.text.trim();
          if (value.isNotEmpty) {
            await user.updateName(value);
          }
        },
      ),
    );

    if (confirmed == true && context.mounted) {
      showAppSnackBar(
        context,
        'Username updated successfully!',
        type: SnackBarType.success,
      );
    }
  }

  // ── Password ──────────────────────────────────────────────────────────────

  void changePassword() {
    showAppSnackBar(context, 'Change password feature coming soon!');
  }

  // ── Delete Account ────────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DialogBox(
        title: 'Delete Account',
        confirmText: 'Delete',
        isDestructive: true,
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be lost.',
        ),
        onConfirm: () async {
          // do nothing OR your delete logic here
        },
      ),
    );

    if (confirmed == true && context.mounted) {
      showAppSnackBar(context, "Delete account feature coming soon!");
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DialogBox(
        title: 'Logout',
        confirmText: 'Logout',
        isDestructive: true,
        content: const Text('Are you sure you want to logout?'),
        onConfirm: () async {
          await user.logout();
        },
      ),
    );

    if (confirmed == true && context.mounted) {
      showAppSnackBar(
        context,
        "Logged out successfully!",
        type: SnackBarType.success,
      );
      context.go('/login');
    }
  }
}