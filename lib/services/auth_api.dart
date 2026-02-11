import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl = 'https://travel-china-api.onrender.com/api/auth';
  static String get _customerUrl => '$_baseUrl/customer';

  /// Register. Returns user_id on success (201), throws [AuthApiException] on error.
  static Future<String> register({
    required String email,
    required String phone,
    required String password,
    required String displayName,
  }) async {
    final uri = Uri.parse('$_customerUrl/register');
    final body = jsonEncode({
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password,
      'display_name': displayName.trim(),
    });
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final decoded = _decodeJson(response.body);
    if (response.statusCode == 201) {
      final data = decoded != null ? decoded['data'] : null;
      final userId = data is Map ? data['user_id']?.toString() : null;
      if (userId == null || userId.isEmpty) {
        throw AuthApiException('Invalid response: missing user_id');
      }
      return userId;
    }
    throw AuthApiException(_extractMessage(decoded, response.statusCode));
  }

  /// Login. Returns Map with access_token and refresh_token on success (200), throws [AuthApiException] on error.
  static Future<Map<String, String>> login({
    required String email,
    required String phone,
    required String password,
  }) async {
    final uri = Uri.parse('$_customerUrl/login');
    final body = jsonEncode({
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password,
    });
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final decoded = _decodeJson(response.body);
    if (response.statusCode == 200) {
      final data = decoded != null ? decoded['data'] : null;
      if (data is! Map) throw AuthApiException('Invalid response: missing data');
      final accessToken = data['access_token']?.toString();
      final refreshToken = data['refresh_token']?.toString();
      if (accessToken == null || accessToken.isEmpty) {
        throw AuthApiException('Invalid response: missing access_token');
      }
      return {
        'access_token': accessToken,
        'refresh_token': refreshToken ?? '',
      };
    }
    throw AuthApiException(_extractMessage(decoded, response.statusCode));
  }

  /// Get current user profile. Requires valid access token. Returns account map (id, email, phone, display_name, ...).
  static Future<Map<String, dynamic>> getMe(String accessToken) async {
    final uri = Uri.parse('$_baseUrl/me');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    final decoded = _decodeJson(response.body);
    if (response.statusCode == 200) {
      final data = decoded != null ? decoded['data'] : null;
      final account = data is Map ? data['account'] : null;
      if (account is! Map<String, dynamic>) {
        throw AuthApiException('Invalid response: missing account');
      }
      return account;
    }
    throw AuthApiException(_extractMessage(decoded, response.statusCode));
  }

  static Map<String, dynamic>? _decodeJson(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  static String _extractMessage(Map<String, dynamic>? decoded, int statusCode) {
    if (decoded != null && decoded['message'] != null) {
      return decoded['message'].toString();
    }
    return 'Request failed (${statusCode})';
  }
}

class AuthApiException implements Exception {
  final String message;
  AuthApiException(this.message);
  @override
  String toString() => message;
}
