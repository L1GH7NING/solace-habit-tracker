import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';
  bool _isGuest = true;

  String get name => _name;
  bool get isGuest => _isGuest;

  String get initial =>
      _name.isNotEmpty ? _name[0].toUpperCase() : '?';

  String get email => FirebaseAuth.instance.currentUser?.email ?? '';

  UserProvider() {
    _init(); // 🔥 auto start listening
  }

  void _init() {
    AuthService.authStateChanges.listen((User? user) async {
      final prefs = await SharedPreferences.getInstance();

      if (user != null) {
        _isGuest = false;
        _name = user.displayName ?? 'User';
      } else {
        _isGuest = true;
        _name = prefs.getString('display_name') ?? 'Guest';
      }

      notifyListeners(); // 🔥 auto update UI everywhere
    });
  }

  // 🔥 Update name globally
  Future<void> updateName(String newName) async {
    _name = newName;
    await AuthService.saveName(newName);
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.signOut();
    // ❌ DON'T manually set values here anymore
    // listener will handle it automatically
  }
}