import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/core/providers/theme_provider.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
// import 'package:zenith_habit_tracker/core/theme/app_colors.dart'; // No longer needed
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/profile/services/profile_service.dart';
import 'package:zenith_habit_tracker/features/profile/widgets/avatar_picker.dart';
import 'package:zenith_habit_tracker/features/profile/widgets/avatar_section.dart';
import 'package:zenith_habit_tracker/features/profile/widgets/guest_banner.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final profileService = ProfileService(context: context, user: user);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🎨 THEME
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'Edit Profile',
          style: theme.textTheme.headlineMedium?.copyWith(
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
              color: theme.colorScheme.primary.withOpacity(0.08), // 🎨 THEME
              size: 260,
            ),
          ),
          Positioned(
            bottom: 120,
            right: -80,
            child: BlurCircle(
              color: theme.colorScheme.secondary.withOpacity(0.12), // 🎨 THEME
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
                        AvatarSection(
                          selectedAvatar: user.avatar ?? user.initial,
                          onTap: () => showAvatarPicker(
                            context,
                            service: profileService,
                          ),
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
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Guest Banner ─────────────────────────────────
                        if (user.isGuest) ...[
                          GuestBanner(theme: theme),
                          const SizedBox(height: 24),
                        ],

                        // ── General (always visible) ─────────────────────
                        const _SectionLabel(label: 'General'),
                        const SizedBox(height: 10),
                        _Section(
                          children: [
                            _InfoTile(
                              label: 'Name',
                              value: user.name,
                              onTap: profileService.changeUsername,
                            ),
                            const _Divider(),
                            _ThemeToggleTile(
                              isDark:
                                  themeProvider.themeMode == ThemeMode.dark ||
                                  (themeProvider.themeMode ==
                                          ThemeMode.system &&
                                      MediaQuery.of(
                                            context,
                                          ).platformBrightness ==
                                          Brightness.dark),
                              onChanged: (isDark) {
                                context.read<ThemeProvider>().toggleTheme(
                                  isDark,
                                );
                              },
                            ),
                          ],
                        ),

                        // ── Private Info (logged in only) ─────────────────
                        if (!user.isGuest) ...[
                          const SizedBox(height: 24),
                          const _SectionLabel(label: 'Private Information'),
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
                          const _SectionLabel(label: 'Account'),
                          const SizedBox(height: 10),
                          _Section(
                            children: [
                              _InfoTile(
                                label: 'Logout',
                                value: '',
                                onTap: profileService.logout,
                                labelColor: theme.colorScheme.error,
                              ),
                              const _Divider(),
                              _InfoTile(
                                label: 'Delete Account',
                                value: '',
                                onTap: profileService.deleteAccount,
                                labelColor: theme.colorScheme.error,
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
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    // 🎨 THEME: No need to override color, headlineMedium already has the correct one
    return Text(
      label,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color, // 🎨 THEME
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04), // 🎨 THEME
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
    final theme = Theme.of(context);
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
                color:
                    labelColor ??
                    theme.colorScheme.onSurfaceVariant, // 🎨 THEME
              ),
            ),
            const Spacer(),
            if (value.isNotEmpty)
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface, // 🎨 THEME
                ),
              ),
            if (onTap != null) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(
                  0.5,
                ), // 🎨 THEME
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
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.surfaceVariant, // 🎨 THEME
    );
  }
}

class _ThemeToggleTile extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ThemeToggleTile({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Text(
            'Dark Mode',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Switch(
            value: isDark,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
