import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestBanner extends StatelessWidget {
  final ThemeData theme;
  const GuestBanner({super.key, required this.theme});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: theme.colorScheme.primary.withOpacity(0.06),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
    ),
    child: Column(
      children: [
        const Text('🔒', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          'Sign in for the best experience - sync your habits, track your streaks and never lose your progress!',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/signup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Create an Account',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}