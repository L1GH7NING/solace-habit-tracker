import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/services/auth_service.dart'; // ⚠️ adjust path

/// Sits at the root of the app and redirects based on auth state.
/// Firebase persists sessions automatically — if the user was logged in,
/// FirebaseAuth.instance.currentUser will be non-null on cold start.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final hasSetName = await AuthService.hasSetName();

          if (user != null) {
            // Logged in — check if they've set a name yet
            context.go(hasSetName ? '/home' : '/set-name');
          } else {
            final hasLaunched = await AuthService.hasLaunched();
            if (!hasLaunched) {
              // Brand new user — show onboarding
              context.go('/onboarding');
            } else if (!hasSetName) {
              // Has launched before (guest) but never set a name
              context.go('/set-name');
            } else {
              context.go('/home');
            }
          }
        });

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}