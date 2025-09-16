import 'dart:convert';
import '../models/models.dart';
import 'api_service.dart';

// PUBLIC_INTERFACE
/// AuthService encapsulates auth-related API calls.
class AuthService {
  final ApiService _api;

  AuthService({String? token}) : _api = ApiService(token: token);

  void updateToken(String? token) => _api.updateToken(token);

  Future<UserPublic> register({required String email, required String password}) async {
    final res = await _api.post('/auth/register', body: {'email': email, 'password': password});
    return UserPublic.fromJson(jsonDecode(res.body));
    }

  Future<Token> login({required String email, required String password}) async {
    // Backend expects form-url-encoded fields: username, password
    final res = await _api.post(
      '/auth/token',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$email&password=$password&scope=',
    );
    return Token.fromJson(jsonDecode(res.body));
  }

  Future<UserPublic> me() async {
    final res = await _api.get('/users/me');
    return UserPublic.fromJson(jsonDecode(res.body));
  }

  Future<void> updatePassword(String newPassword) async {
    await _api.post('/users/me/password', body: {'new_password': newPassword});
  }
}
