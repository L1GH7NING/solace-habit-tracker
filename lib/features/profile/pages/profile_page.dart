import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'package:zenith_habit_tracker/core/theme/app_colors.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/profile/services/profile_service.dart';

const _avatarOptions = [
  '🧑',
  '👩',
  '🧔',
  '👱',
  '🧕',
  '👴',
  '👵',
  '🧒',
  '🦊',
  '🐻',
  '🐼',
  '🐨',
  '🐯',
  '🦁',
  '🐸',
  '🐙',
  '🌟',
  '🔥',
  '🌈',
  '🎯',
  '🚀',
  '🎨',
  '🎸',
  '⚡',
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _selectedAvatar = '🧑';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserProvider>();
    final profileService = ProfileService(context: context, user: user);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70, // increases vertical space
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          // 🔮 Background blobs
          Positioned(
            top: 120,
            left: -80,
            child: BlurCircle(
              color: AppColors.primary.withOpacity(0.08),
              size: 260,
            ),
          ),
          Positioned(
            bottom: 120,
            right: -80,
            child: BlurCircle(
              color: AppColors.secondary.withOpacity(0.12),
              size: 300,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Avatar ───────────────────────────────────────
                        _AvatarSection(
                          selectedAvatar: _selectedAvatar,
                          onTap: () =>
                              _showAvatarPicker(context, profileService),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: Text(
                            user.name,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 20,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            user.isGuest ? 'Browsing as guest' : user.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Guest Banner ─────────────────────────────────
                        if (user.isGuest) ...[
                          _GuestBanner(),
                          const SizedBox(height: 24),
                        ],

                        // ── General (always visible) ─────────────────────
                        _SectionLabel(label: 'General'),
                        const SizedBox(height: 10),
                        _Section(
                          children: [
                            _InfoTile(
                              label: 'Name',
                              value: user.name,
                              onTap: profileService.changeUsername,
                            ),
                          ],
                        ),

                        // ── Private Info (logged in only) ─────────────────
                        if (!user.isGuest) ...[
                          const SizedBox(height: 24),
                          _SectionLabel(label: 'Private Information'),
                          const SizedBox(height: 10),
                          _Section(
                            children: [
                              _InfoTile(
                                label: 'Email',
                                value: user.email.isNotEmpty ? user.email : '—',
                                onTap: null,
                              ),
                              const _Divider(),
                              _InfoTile(
                                label: 'Password',
                                value: '••••••••',
                                onTap: profileService.changePassword,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          _SectionLabel(label: 'Account'),
                          const SizedBox(height: 10),
                          _Section(
                            children: [
                              _InfoTile(
                                label: 'Logout',
                                value: '',
                                onTap: profileService.logout,
                                labelColor: Theme.of(context).colorScheme.error,
                              ),
                              const _Divider(),
                              _InfoTile(
                                label: 'Delete Account',
                                value: '',
                                onTap: profileService.deleteAccount,
                                labelColor: Theme.of(context).colorScheme.error,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Avatar picker sheet ────────────────────────────────────────────────────
  void _showAvatarPicker(BuildContext context, ProfileService service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Avatar',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _avatarOptions.length,
              itemBuilder: (_, i) {
                final emoji = _avatarOptions[i];
                final isSelected = emoji == _selectedAvatar;
                return GestureDetector(
                  onTap: () {
                    service.onAvatarSelected(
                      emoji,
                      () => setState(() => _selectedAvatar = emoji),
                    );
                    Navigator.pop(ctx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(emoji, style: const TextStyle(fontSize: 26)),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private UI-only sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // controls vertical position area
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: Alignment(0, 0.3), // push slightly downward
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Edit Profile',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String selectedAvatar;
  final VoidCallback onTap;

  const _AvatarSection({required this.selectedAvatar, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(selectedAvatar, style: const TextStyle(fontSize: 48)),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/signup'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text('🔒', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 10),
            const Text(
              'You\'re not signed in',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sign in for the best experience — sync your habits, track streaks, and never lose your progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Text(
                'Sign In for Best Experience',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Color? labelColor;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: labelColor ?? AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (value.isNotEmpty)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            if (onTap != null) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 18,
      endIndent: 18,
      color: Color(0xFFEEEEF2),
    );
  }
}
