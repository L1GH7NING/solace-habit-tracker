import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/common/widgets/bottom_nav.dart';
import 'package:zenith_habit_tracker/features/habits/pages/create_habit_page.dart';
import 'package:zenith_habit_tracker/features/habits/pages/habit_info_page.dart';
import 'package:zenith_habit_tracker/features/profile/pages/profile_page.dart';
import 'package:zenith_habit_tracker/pages/set_name_page.dart';
import '../../pages/onboarding_page.dart';
import '../../features/auth/pages/signup_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../auth_gate.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/providers/user_provider.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // ── Auth flow (no bottom nav) ─────────────────────────────────────────
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/set-name',
        name: 'setName',
        builder: (context, state) => const SetNamePage(),
      ),
      GoRoute(
        path: '/habit-info',
        name: 'habitInfo',
        builder: (context, state) {
          final habit = state.extra as Habit;
          return HabitInfoPage(habit: habit);
        },
      ),

      // ── Main app shell (persistent bottom nav) ────────────────────────────
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/stats',
            name: 'stats',
            builder: (context, state) => const _PlaceholderPage(title: 'Stats'),
          ),
          GoRoute(
            path: '/add-habit',
            name: 'addHabit',
            builder: (context, state) => const CreateHabitPage(),
          ),
          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Community'),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  final Widget child;
  const _AppShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      // 1. Remove the bottom padding injected by bottomNavigationBar
      // This tells inner pages to draw underneath the floating pill.
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: child,
      ),
      bottomNavigationBar: BottomNav(isGuest: user.isGuest),
    );
  }
}

// ── Placeholder for unbuilt pages ─────────────────────────────────────────────
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
