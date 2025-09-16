import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Lightweight REST API client wrapping http with base URL and auth headers.
/// Reads BACKEND_BASE_URL from the .env file.
/// Do not hardcode secrets; ensure .env has BACKEND_BASE_URL=https://host:port
class ApiService {
  ApiService({String? token}) : _token = token;

  String? _token;

  // PUBLIC_INTERFACE
  /// Update bearer token used in subsequent requests.
  void updateToken(String? token) {
    _token = token;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = dotenv.env['BACKEND_BASE_URL'] ?? '';
    final normalized = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final full = '$normalized$path';
    return Uri.parse(full).replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')));
  }

  Map<String, String> _headers({Map<String, String>? extra}) {
    final base = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      base['Authorization'] = 'Bearer $_token';
    }
    if (extra != null) base.addAll(extra);
    return base;
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    final res = await http.get(_uri(path, query), headers: _headers());
    _throwIfError(res);
    return res;
  }

  Future<http.Response> post(String path, {Object? body, Map<String, dynamic>? query, Map<String, String>? headers}) async {
    final res = await http.post(
      _uri(path, query),
      headers: _headers(extra: headers),
      body: body is String ? body : jsonEncode(body),
    );
    _throwIfError(res);
    return res;
  }

  Future<http.Response> put(String path, {Object? body}) async {
    final res = await http.put(_uri(path), headers: _headers(), body: body is String ? body : jsonEncode(body));
    _throwIfError(res);
    return res;
  }

  Future<http.Response> delete(String path) async {
    final res = await http.delete(_uri(path), headers: _headers());
    _throwIfError(res);
    return res;
  }

  void _throwIfError(http.Response res) {
    if (res.statusCode >= 400) {
      if (kDebugMode) {
        debugPrint('HTTP ${res.statusCode}: ${res.body}');
      }
      throw HttpException('HTTP ${res.statusCode}', body: res.body);
    }
  }
}

// PUBLIC_INTERFACE
/// Simple HTTP exception carrying response body for debugging.
class HttpException implements Exception {
  final String message;
  final String? body;
  HttpException(this.message, {this.body});
  @override
  String toString() => 'HttpException($message, body: $body)';
}
