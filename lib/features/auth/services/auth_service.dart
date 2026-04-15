import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔐 Email & Password Sign Up
  static Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _setHasLaunched();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_friendlyError(e.code));
    } catch (_) {
      return AuthResult.failure("Something went wrong. Please try again.");
    }
  }

  // 🔑 Email & Password Sign In
  static Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _setHasLaunched();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_friendlyError(e.code));
    } catch (_) {
      return AuthResult.failure("Something went wrong. Please try again.");
    }
  }

  // 🔵 Google Sign In
  static Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return AuthResult.cancelled();

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      await _setHasLaunched();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_friendlyError(e.code));
    } catch (_) {
      return AuthResult.failure("Google sign-in failed. Please try again.");
    }
  }

  // 👤 Continue as Guest
  static Future<void> continueAsGuest() async {
    await _setHasLaunched();
  }

  // 🚪 Logout
  static Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // 🏁 Has the user been through onboarding before?
  static Future<bool> hasLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_launched') ?? false;
  }

  // ✅ Per-account name check
  static Future<bool> hasSetName() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.displayName != null && user.displayName!.trim().isNotEmpty;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guest_name_set') ?? false;
  }

  // 💾 Save name — to Firebase if logged in, to prefs if guest
  static Future<void> saveName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('display_name', name);
    await prefs.setBool('guest_name_set', true);
  }

  // 📛 Get display name for whoever is using the app right now
  static Future<String> getDisplayName() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
        return user.displayName!;
      }
      return user.email ?? "User";
    }
    // Guest — read from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('display_name') ?? "Guest";
  }

  static Future<void> _setHasLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_launched', true);
  }

  // 🗣️ Human-readable Firebase errors
  static String _friendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "An account with this email already exists.";
      case 'invalid-email':
        return "Please enter a valid email address.";
      case 'weak-password':
        return "Password must be at least 6 characters.";
      case 'operation-not-allowed':
        return "Email sign-in is not enabled.";
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return "Incorrect email or password.";
      case 'user-disabled':
        return "This account has been disabled.";
      case 'too-many-requests':
        return "Too many attempts. Please try again later.";
      default:
        return "Something went wrong. Please try again.";
    }
  }

  static Future<void> saveAvatar(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    final user = _auth.currentUser;

    // Use the UID for a logged-in user, or a static key for a guest.
    final key = user != null ? 'avatar_${user.uid}' : 'avatar_guest';
    await prefs.setString(key, emoji);
  }

  
  static Future<String?> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final user = _auth.currentUser;

    final key = user != null ? 'avatar_${user.uid}' : 'avatar_guest';
    return prefs.getString(key);
  }

}

// ── Result type ──────────────────────────────────────────────────────────────
class AuthResult {
  final bool success;
  final bool cancelled;
  final String? error;

  AuthResult._({required this.success, required this.cancelled, this.error});

  factory AuthResult.success() =>
      AuthResult._(success: true, cancelled: false);

  factory AuthResult.failure(String error) =>
      AuthResult._(success: false, cancelled: false, error: error);

  factory AuthResult.cancelled() =>
      AuthResult._(success: false, cancelled: true);
}