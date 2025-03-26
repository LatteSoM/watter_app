import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  Future<bool> signIn(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_emailKey);
    final storedPassword = prefs.getString(_passwordKey);
    return storedEmail == email && storedPassword == password;
  }

  Future<bool> signUp(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    return true;
  }
}