import 'package:go_router/go_router.dart';
import 'package:zenith_habit_tracker/pages/set_name_page.dart';
import '../../pages/onboarding_page.dart';
import '../../pages/signup_page.dart';
import '../../pages/home_page.dart';
import '../../auth_gate.dart';
import '../../pages/login_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
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
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/set-name',
        name: 'setName',
        builder: (context, state) => const SetNamePage(),
      ),
    ],
  );
}
