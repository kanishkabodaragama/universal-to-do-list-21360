import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/auth_service.dart';

// PUBLIC_INTERFACE
/// AuthProvider maintains authentication state, token persistence,
/// and exposes login/logout/register operations.
class AuthProvider extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  final AuthService _auth = AuthService();

  String? _token;
  UserPublic? _user;
  bool _loading = false;

  String? get token => _token;
  UserPublic? get user => _user;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  bool get loading => _loading;

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_tokenKey);
    if (saved != null && saved.isNotEmpty) {
      _token = saved;
      _auth.updateToken(_token);
      try {
        _user = await _auth.me();
      } catch (_) {
        // token might be invalid/expired
        await logout();
      }
    }
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> register(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      await _auth.register(email: email, password: password);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final token = await _auth.login(email: email, password: password);
      _token = token.accessToken;
      _auth.updateToken(_token);
      await _saveToken(_token!);
      _user = await _auth.me();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _auth.updateToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }

  Future<void> updatePassword(String newPassword) async {
    _loading = true;
    notifyListeners();
    try {
      await _auth.updatePassword(newPassword);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
