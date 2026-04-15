import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;

  static const double _buttonRadius = 40.0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSuccessAndNavigate() {
      showAppSnackBar(context, 'Account created successfully!', type: SnackBarType.success);

    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      // Google users already have a displayName — skip /set-name for them
      final hasSetName = await AuthService.hasSetName();
      context.go(hasSetName ? '/home' : '/set-name');
    });
  }

  // 🔐 Email & Password Sign Up
  Future<void> _signUpWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = "Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = "Passwords do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.signUpWithEmail(
      email: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      _showSuccessAndNavigate();
    } else {
      setState(() => _errorMessage = result.error);
    }
  }

  // 🔵 Google Sign In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isGoogleLoading = false);

    if (result.success) {
      _showSuccessAndNavigate();
    } else if (!result.cancelled) {
      setState(() => _errorMessage = result.error);
    }
  }

  // 👤 Continue as Guest
  Future<void> _continueAsGuest() async {
    await AuthService.continueAsGuest();
    if (!mounted) return;

    final hasSetName = await AuthService.hasSetName();
    context.go(hasSetName ? '/home' : '/set-name');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 120,
            left: -80,
            child: BlurCircle(
              color: theme.colorScheme.primary.withOpacity(0.15),
              size: 250,
            ),
          ),
          Positioned(
            bottom: 120,
            right: -80,
            child: BlurCircle(
              color: theme.colorScheme.secondary.withOpacity(0.2),
              size: 300,
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                            Text(
                              "Create Account",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                "Build habits that actually stick.",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),

                            const SizedBox(height: 32),

                            _googleButton(context),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    "or",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.12),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            _inputField(
                              context,
                              label: "Email",
                              icon: Icons.mail,
                              hint: "julian@example.com",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 20),

                            _inputField(
                              context,
                              label: "Password",
                              icon: Icons.lock,
                              hint: "••••••••",
                              obscure: true,
                              controller: _passwordController,
                            ),

                            const SizedBox(height: 20),

                            _inputField(
                              context,
                              label: "Confirm Password",
                              icon: Icons.lock_outline,
                              hint: "••••••••",
                              obscure: true,
                              controller: _confirmPasswordController,
                            ),

                            if (_errorMessage != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withOpacity(
                                    0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      size: 18,
                                      color: theme.colorScheme.error,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.error,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 30),

                            _primaryButton(context),

                            const SizedBox(height: 24),

                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: theme.textTheme.bodyMedium,
                                  children: [
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () => context.push('/login'),
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: TextButton(
                                onPressed: _continueAsGuest,
                                child: Text(
                                  "Continue as guest",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
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

  Widget _googleButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_buttonRadius),
      ),
      child: OutlinedButton(
        onPressed: _isGoogleLoading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          side: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.08),
          ),
          backgroundColor: theme.colorScheme.surface,
        ),
        child: SizedBox(
          width: double.infinity,
          child: _isGoogleLoading
              ? Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/google-logo.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Continue with Google",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _inputField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType? keyboardType,
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
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
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

  Widget _primaryButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signUpWithEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
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
}
