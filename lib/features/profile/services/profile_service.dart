import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';

class ProfileService {
  final BuildContext context;
  final UserProvider user;

  ProfileService({required this.context, required this.user});

  // ── Avatar ────────────────────────────────────────────────────────────────

  /// Called when user selects an avatar emoji from the picker.
  void onAvatarSelected(String emoji, VoidCallback updateState) {
    updateState();
    // TODO: persist avatar choice to SharedPreferences or Firestore
  }

  // ── Username ──────────────────────────────────────────────────────────────

  Future<void> changeUsername() async {
    final nameController = TextEditingController(text: user.name);

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Change Username',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: Color(0xFF1C1C1E),
          ),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration:
              const InputDecoration(hintText: 'Enter new username'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(ctx, nameController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await user.updateName(result);
      if (context.mounted) _showSuccessSnackbar('Username updated!');
    }
  }

  // ── Password ──────────────────────────────────────────────────────────────

  void changePassword() {
    _showComingSoonSnackbar('Change password');
  }

  // ── Delete Account ────────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    final theme = Theme.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF1C1C1E),
          ),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be lost.',
          style: TextStyle(color: Color(0xFF78767C)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // TODO: implement actual account deletion via Firebase
      _showComingSoonSnackbar('Account deletion');
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await user.logout();
    if (context.mounted) context.go('/login');
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showComingSoonSnackbar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }
}