import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // 🔮 Background Blobs (same as onboarding)
          Positioned(
            top: 120,
            left: -80,
            child: _blurCircle(
              theme.colorScheme.primary.withOpacity(0.15),
              250,
            ),
          ),
          Positioned(
            bottom: 120,
            right: -80,
            child: _blurCircle(
              theme.colorScheme.secondary.withOpacity(0.2),
              300,
            ),
          ),

          // 📱 Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⬅️ Back Button
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      const SizedBox(height: 20),

                      // 🧠 Title — bolder, tighter tracking
                      Text(
                        "Create Account",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Build habits that actually stick.",
                        style: theme.textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 40),

                      // ✍️ Name
                      _inputField(
                        context,
                        label: "Full Name",
                        icon: Icons.person,
                        hint: "Julian Rivers",
                      ),

                      const SizedBox(height: 20),

                      // 📧 Email
                      _inputField(
                        context,
                        label: "Email",
                        icon: Icons.mail,
                        hint: "julian@example.com",
                      ),

                      const SizedBox(height: 20),

                      // 🔒 Password
                      _inputField(
                        context,
                        label: "Password",
                        icon: Icons.lock,
                        hint: "••••••••",
                        obscure: true,
                      ),

                      const SizedBox(height: 30),

                      // 🚀 Gradient Button (same as onboarding)
                      _primaryButton(context),

                      const SizedBox(height: 24),

                      // 🔁 Login Link
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 👤 Continue as Guest
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.go('/home'); // change route if needed
                          },
                          child: Text(
                            "Continue as guest",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                          ],
                        ),
                      ),
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

  // 🔹 Input Field (matches theme + soft UI)
  Widget _inputField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String hint,
    bool obscure = false,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // 🎯 Gradient Button (REUSED STYLE)
  Widget _primaryButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.go('/home'); // change route if needed
        },
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
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              "Create Account",
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🌫️ Blur Circle (same as onboarding)
  Widget _blurCircle(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}