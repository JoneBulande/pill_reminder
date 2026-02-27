import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyName = 'userName';
  static const _keyEmail = 'email';
  static const _keyPass = 'pass';

  // Salvar os dados de login
  Future<void> saveUserData(String name, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyName, name);
    // await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPass, pass);
  }


  // Verificar se o usuário está logado
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Obter o nome do usuário
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  // Realizar o logout (remover dados)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPass);
  }
}
