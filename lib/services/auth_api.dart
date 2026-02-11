import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl = 'https://travel-china-api.onrender.com/api';

  /// Register (role CUSTOMER). Returns user_id on 201. Throws [AuthApiException] on error.
  static Future<String> register({
    required String phoneNumber,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/register');
    final body = jsonEncode({
      'role': 'CUSTOMER',
      'phone_number': phoneNumber.trim(),
      'password': password,
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

  /// Send verification code to phone. 200 = success.
  static Future<void> sendPhoneCode({required String phoneNumber}) async {
    final uri = Uri.parse('$_baseUrl/auth/send-phone-code');
    final body = jsonEncode({'phone_number': phoneNumber.trim()});
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final decoded = _decodeJson(response.body);
    if (response.statusCode == 200) return;
    throw AuthApiException(_extractMessage(decoded, response.statusCode));
  }

  /// Verify phone with code. 200 = success.
  static Future<void> verifyPhone({
    required String phoneNumber,
    required String code,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/verify-phone');
    final body = jsonEncode({
      'phone_number': phoneNumber.trim(),
      'code': code.trim(),
    });
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final decoded = _decodeJson(response.body);
    if (response.statusCode == 200) return;
    throw AuthApiException(_extractMessage(decoded, response.statusCode));
  }

  /// Login. Returns access_token and refresh_token on 200.
  static Future<Map<String, String>> login({
    required String phoneNumber,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final body = jsonEncode({
      'phone_number': phoneNumber.trim(),
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

  /// Get current user (GET /api/auth/me). Returns { account, profile }.
  static Future<Map<String, dynamic>> getMe(String accessToken) async {
    final uri = Uri.parse('$_baseUrl/auth/me');
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
      if (data is! Map<String, dynamic>) {
        throw AuthApiException('Invalid response: missing data');
      }
      return data;
    }
    throw AuthApiException(_extractMessage(decoded, response.statusCode));
  }

  /// Update customer profile (PATCH /api/customer/profile).
  static Future<Map<String, dynamic>> updateProfile(
    String accessToken, {
    String? displayName,
    String? avatarUrl,
    String? contactEmail,
  }) async {
    final uri = Uri.parse('$_baseUrl/customer/profile');
    final body = <String, dynamic>{};
    if (displayName != null) body['display_name'] = displayName.trim();
    if (avatarUrl != null) body['avatar_url'] = avatarUrl.trim();
    if (contactEmail != null) body['contact_email'] = contactEmail.trim();
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );
    final decoded = _decodeJson(response.body);
    if (response.statusCode == 200) {
      final data = decoded != null ? decoded['data'] : null;
      if (data is! Map<String, dynamic>) {
        throw AuthApiException('Invalid response: missing data');
      }
      return data;
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
    return 'Request failed ($statusCode)';
  }
}

class AuthApiException implements Exception {
  final String message;
  AuthApiException(this.message);
  @override
  String toString() => message;
}
