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

  /// Build User and save to prefs from /me API account map.
  static Future<User> _userFromAccount(SharedPreferences prefs, Map<String, dynamic> account) async {
    final id = account['id']?.toString() ?? '';
    final email = account['email']?.toString() ?? '';
    final phone = account['phone']?.toString() ?? '';
    final name = account['display_name']?.toString() ?? email.split('@').first;
    final user = User(id: id, name: name, email: email, phone: phone);
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserPhone, user.phone!);
    return user;
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
      final accessToken = prefs.getString(_keyAccessToken);

      if (accessToken != null && accessToken.isNotEmpty) {
        try {
          final account = await AuthApi.getMe(accessToken);
          _currentUser = await _userFromAccount(prefs, account);
          _walletBalance = 500.0;
        } catch (e) {
          debugPrint('AppProvider.init getMe error: $e');
          await _clearAuthPrefs(prefs);
          _currentUser = null;
          _walletBalance = 0.0;
        }
      } else {
        _currentUser = null;
        _walletBalance = 0.0;
      }

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

  Future<void> _clearAuthPrefs(SharedPreferences prefs) async {
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
  }

  /// Login via API, then fetch profile from /me to get display_name from DB.
  Future<void> login(String email, String phone, String password) async {
    if (email.trim().isEmpty || phone.trim().isEmpty || password.isEmpty) return;
    final tokens = await AuthApi.login(email: email, phone: phone, password: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, tokens['access_token']!);
    await prefs.setString(_keyRefreshToken, tokens['refresh_token'] ?? '');
    final account = await AuthApi.getMe(tokens['access_token']!);
    _currentUser = await _userFromAccount(prefs, account);
    _walletBalance = 500.0;
    notifyListeners();
  }

  /// Register via API, then login and fetch profile from /me (display_name from DB).
  Future<void> register(String displayName, String phone, String email, String password) async {
    if (displayName.trim().isEmpty || phone.trim().isEmpty || email.trim().isEmpty || password.isEmpty) return;
    await AuthApi.register(
      email: email,
      phone: phone,
      password: password,
      displayName: displayName,
    );
    final tokens = await AuthApi.login(email: email, phone: phone, password: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, tokens['access_token']!);
    await prefs.setString(_keyRefreshToken, tokens['refresh_token'] ?? '');
    final account = await AuthApi.getMe(tokens['access_token']!);
    _currentUser = await _userFromAccount(prefs, account);
    _walletBalance = 500.0;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await _clearAuthPrefs(prefs);
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

