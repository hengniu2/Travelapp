import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../services/auth_api.dart';

class AppProvider with ChangeNotifier {
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUserName = 'user_name';
  static const _keyUserPhone = 'user_phone';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyDisplayNameCache = 'display_name_cache';

  static String _cacheKey(String email, String phone) =>
      '${email.trim().toLowerCase()}|${phone.replaceAll(RegExp(r"\D"), "")}';

  static String? _getDisplayNameFromCache(SharedPreferences prefs, String email, String phone) {
    final json = prefs.getString(_keyDisplayNameCache);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>?;
      return map?[_cacheKey(email, phone)]?.toString();
    } catch (_) {
      return null;
    }
  }

  static Future<void> _saveDisplayNameToCache(SharedPreferences prefs, String email, String phone, String displayName) async {
    final key = _cacheKey(email, phone);
    final json = prefs.getString(_keyDisplayNameCache);
    Map<String, dynamic> map = {};
    if (json != null) {
      try {
        final decoded = jsonDecode(json);
        if (decoded is Map<String, dynamic>) map = decoded;
      } catch (_) {}
    }
    map[key] = displayName;
    await prefs.setString(_keyDisplayNameCache, jsonEncode(map));
  }

  User? _currentUser;
  final List<Order> _orders = [];
  final List<String> _favorites = [];
  double _walletBalance = 0.0;
  Locale _locale = const Locale('zh');
  bool _initialized = false;

  User? get currentUser => _currentUser;
  List<Order> get orders => _orders;
  List<String> get favorites => _favorites;
  double get walletBalance => _walletBalance;
  Locale get locale => _locale;
  bool get isInitialized => _initialized;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void toggleFavorite(String itemId) {
    if (_favorites.contains(itemId)) {
      _favorites.remove(itemId);
    } else {
      _favorites.add(itemId);
    }
    notifyListeners();
  }

  bool isFavorite(String itemId) {
    return _favorites.contains(itemId);
  }

  void addToWallet(double amount) {
    _walletBalance += amount;
    notifyListeners();
  }

  void deductFromWallet(double amount) {
    _walletBalance -= amount;
    notifyListeners();
  }

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load saved user and tokens (stay logged in)
      final userId = prefs.getString(_keyUserId);
      final userEmail = prefs.getString(_keyUserEmail);
      final userName = prefs.getString(_keyUserName);
      final userPhone = prefs.getString(_keyUserPhone);
      final accessToken = prefs.getString(_keyAccessToken);
      final hasValidSession = accessToken != null &&
          accessToken.isNotEmpty &&
          userId != null &&
          userEmail != null &&
          userName != null &&
          userPhone != null;
      if (hasValidSession) {
        _currentUser = User(
          id: userId,
          name: userName,
          email: userEmail,
          phone: userPhone,
        );
        _walletBalance = 500.0;
      } else {
        _currentUser = null;
        _walletBalance = 0.0;
      }

      // Load saved language preference (default: Chinese)
      final savedLanguage = prefs.getString('language_code');
      _locale = Locale(savedLanguage ?? 'zh');
    } catch (e) {
      debugPrint('AppProvider.init error: $e');
      _currentUser = null;
      _walletBalance = 0.0;
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  /// Login via API. Uses display name from cache (saved at register) when available.
  Future<void> login(String email, String phone, String password) async {
    if (email.trim().isEmpty || phone.trim().isEmpty || password.isEmpty) return;
    final tokens = await AuthApi.login(email: email, phone: phone, password: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, tokens['access_token']!);
    await prefs.setString(_keyRefreshToken, tokens['refresh_token'] ?? '');
    final userId = prefs.getString(_keyUserId);
    final savedEmail = prefs.getString(_keyUserEmail);
    final savedPhone = prefs.getString(_keyUserPhone);
    final sameUser = savedEmail == email.trim() && savedPhone == phone.trim();
    final id = userId != null && sameUser ? userId : DateTime.now().millisecondsSinceEpoch.toString();
    final name = _getDisplayNameFromCache(prefs, email, phone) ??
        (sameUser ? prefs.getString(_keyUserName) : null) ??
        email.trim().split('@').first;
    final user = User(
      id: id,
      name: name,
      email: email.trim(),
      phone: phone.trim(),
    );
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserPhone, user.phone!);
    _currentUser = user;
    _walletBalance = 500.0;
    notifyListeners();
  }

  /// Register via API, then login to get tokens. Saves user and caches display name for future logins.
  Future<void> register(String displayName, String phone, String email, String password) async {
    if (displayName.trim().isEmpty || phone.trim().isEmpty || email.trim().isEmpty || password.isEmpty) return;
    final userId = await AuthApi.register(
      email: email,
      phone: phone,
      password: password,
      displayName: displayName,
    );
    final tokens = await AuthApi.login(email: email, phone: phone, password: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, tokens['access_token']!);
    await prefs.setString(_keyRefreshToken, tokens['refresh_token'] ?? '');
    await _saveDisplayNameToCache(prefs, email, phone, displayName.trim());
    final user = User(
      id: userId,
      name: displayName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      joinDate: DateTime.now(),
    );
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserPhone, user.phone!);
    _currentUser = user;
    _walletBalance = 500.0;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    _currentUser = null;
    _orders.clear();
    _favorites.clear();
    _walletBalance = 0.0;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }
}

