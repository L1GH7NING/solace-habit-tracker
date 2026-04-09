import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // 🔮 Background Blobs
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
          Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      80,
                      24,
                      0,
                    ),
                    child: Column(
                      children: [
                        // 🎬 Lottie Animation
                        Center(child: _lottieAnimation()),

                        const SizedBox(height: 40),

                        // 🧠 Headline
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "Build healthy "),
                              TextSpan(
                                text: "habits",
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const TextSpan(text: " with Solace"),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge,
                        ),

                        const SizedBox(height: 16),

                        // 📝 Subtitle
                        Text(
                          "Consistency is key. We'll help you get there.",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 40),

                        // 🚀 Primary Button
                        _primaryButton(context),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🎬 Lottie Animation
  Widget _lottieAnimation() {
    return SizedBox(
      height: 260,
      width: 260,
      child: Lottie.asset(
        "assets/animations/Cycling.json",
        fit: BoxFit.contain,
      ),
    );
  }

  // 🎯 Gradient Button (modern + theme-based)
  Widget _primaryButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.push('/signup'); // ✅ push keeps onboarding in the stack
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
              "Get started",
              style: theme.textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  // 🌫️ Blur Circle
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