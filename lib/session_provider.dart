import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionProvider extends ChangeNotifier {
  String? _role;
  String? _token;

  // Getter
  String? get role     => _role;
  bool get isLoggedIn  => _token != null;
  bool get isAdmin     => _role == 'admin';
  bool get isUser      => _role == 'user';

  // TODO: Login nanti konek ke database dlu untuk ambil token (id user) sama role nya (admin atau user)
  Future<void> login(String token, String role) async {
    _token = token;
    _role = role;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);

    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');

    notifyListeners();
  }

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _role = prefs.getString('role');

    notifyListeners();
  }
}