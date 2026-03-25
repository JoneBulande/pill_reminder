import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true; // true while restoring session
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';

  AuthProvider() {
    _restoreSession();
  }

  /// Called once at startup – reads SharedPreferences and restores state.
  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (loggedIn) {
      _isLoggedIn = true;
      _userName = prefs.getString(_keyUserName);
      _userEmail = prefs.getString(_keyUserEmail);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String userName, {String? email}) async {
    _isLoggedIn = true;
    _userName = userName;
    _userEmail = email;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserName, userName);
    if (email != null) await prefs.setString(_keyUserEmail, email);

    notifyListeners();
  }

  /// Update display name (profile edit).
  Future<void> updateUserName(String newName) async {
    _userName = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, newName);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);

    notifyListeners();
  }
}
