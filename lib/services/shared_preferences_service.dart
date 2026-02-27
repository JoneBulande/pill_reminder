// import 'package:flutter/material.dart';
// import 'package:pill_reminder/services/shared_preferences.dart';

// class AuthProvider with ChangeNotifier {
//   final SharedPreferencesService _prefsService = SharedPreferencesService();
//   String? _userName;

//   String? get userName => _userName;

//   Future<void> checkLoginStatus() async {
//     bool isLoggedIn = await _prefsService.isUserLoggedIn();
//     if (isLoggedIn) {
//       _userName = await _prefsService.getUserName();
//       notifyListeners();
//     }
//   }

// Future<void> login(String name, String pass) async {
//   try {
//     await _prefsService.saveUserData(name, pass);
//     _userName = name;
//     notifyListeners();
//     print(_userName);
//   } catch (e) {
//     // Aqui você pode adicionar algum tratamento de erro
//     print('Erro ao fazer login: $e');
//   }
// }

//   Future<void> logout() async {
//     await _prefsService.logout();
//     _userName = null;
//     notifyListeners();
//   }
// }
