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
  static const _keyUserAvatar = 'user_avatar';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  /// Build User from /me API data (account + profile). Saves to prefs.
  static Future<User> _userFromMe(SharedPreferences prefs, Map<String, dynamic> data) async {
    final account = data['account'] is Map ? data['account'] as Map<String, dynamic> : <String, dynamic>{};
    final profile = data['profile'] is Map ? data['profile'] as Map<String, dynamic> : <String, dynamic>{};
    final id = account['id']?.toString() ?? '';
    final phone = account['phone_number']?.toString() ?? '';
    final name = profile['display_name']?.toString()?.trim() ?? '';
    final email = profile['contact_email']?.toString()?.trim() ?? '';
    final avatar = profile['avatar_url']?.toString()?.trim();
    final user = User(
      id: id,
      name: name.isEmpty ? (phone.isNotEmpty ? phone : 'User') : name,
      email: email,
      avatar: avatar,
      phone: phone,
    );
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserName, user.name);
    if (user.phone != null) await prefs.setString(_keyUserPhone, user.phone!);
    if (user.avatar != null) await prefs.setString(_keyUserAvatar, user.avatar!);
    return user;
  }

  User? _currentUser;
  bool _needsProfileCompletion = false;
  final List<Order> _orders = [];
  final List<String> _favorites = [];
  double _walletBalance = 0.0;
  Locale _locale = const Locale('zh');
  bool _initialized = false;

  User? get currentUser => _currentUser;
  bool get needsProfileCompletion => _needsProfileCompletion;
  List<Order> get orders => _orders;
  List<String> get favorites => _favorites;
  double get walletBalance => _walletBalance;
  Locale get locale => _locale;
  bool get isInitialized => _initialized;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setNeedsProfileCompletion(bool value) {
    _needsProfileCompletion = value;
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
          final data = await AuthApi.getMe(accessToken);
          _currentUser = await _userFromMe(prefs, data);
          final profile = data['profile'] is Map ? data['profile'] as Map<String, dynamic> : null;
          final displayName = profile?['display_name']?.toString()?.trim();
          _needsProfileCompletion = displayName == null || displayName.isEmpty;
          _walletBalance = 500.0;
        } catch (e) {
          debugPrint('AppProvider.init getMe error: $e');
          await _clearAuthPrefs(prefs);
          _currentUser = null;
          _needsProfileCompletion = false;
          _walletBalance = 0.0;
        }
      } else {
        _currentUser = null;
        _needsProfileCompletion = false;
        _walletBalance = 0.0;
      }

      final savedLanguage = prefs.getString('language_code');
      _locale = Locale(savedLanguage ?? 'zh');
    } catch (e) {
      debugPrint('AppProvider.init error: $e');
      _currentUser = null;
      _needsProfileCompletion = false;
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
    await prefs.remove(_keyUserAvatar);
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
  }

  /// Login: phone + password. On success fetches /me; if no display_name sets needsProfileCompletion.
  Future<void> login(String phoneNumber, String password) async {
    if (phoneNumber.trim().isEmpty || password.isEmpty) return;
    final tokens = await AuthApi.login(phoneNumber: phoneNumber.trim(), password: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, tokens['access_token']!);
    await prefs.setString(_keyRefreshToken, tokens['refresh_token'] ?? '');
    final data = await AuthApi.getMe(tokens['access_token']!);
    _currentUser = await _userFromMe(prefs, data);
    final profile = data['profile'] is Map ? data['profile'] as Map<String, dynamic> : null;
    final displayName = profile?['display_name']?.toString()?.trim();
    _needsProfileCompletion = displayName == null || displayName.isEmpty;
    _walletBalance = 500.0;
    notifyListeners();
  }

  /// Register: phone + password only. Does not login; caller navigates to phone verification.
  static Future<String> register(String phoneNumber, String password) async {
    if (phoneNumber.trim().isEmpty || password.isEmpty) {
      throw AuthApiException('Phone and password required');
    }
    return AuthApi.register(phoneNumber: phoneNumber.trim(), password: password);
  }

  /// Update profile via PATCH /api/customer/profile, then refresh user and clear needsProfileCompletion.
  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
    String? contactEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_keyAccessToken);
    if (accessToken == null || accessToken.isEmpty) return;
    await AuthApi.updateProfile(
      accessToken,
      displayName: displayName,
      avatarUrl: avatarUrl,
      contactEmail: contactEmail,
    );
    final data = await AuthApi.getMe(accessToken);
    _currentUser = await _userFromMe(prefs, data);
    _needsProfileCompletion = false;
    notifyListeners();
  }

  /// After profile update (PATCH), refresh user from /me and clear needsProfileCompletion.
  Future<void> refreshUserAfterProfileUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_keyAccessToken);
    if (accessToken == null || accessToken.isEmpty) return;
    final data = await AuthApi.getMe(accessToken);
    _currentUser = await _userFromMe(prefs, data);
    _needsProfileCompletion = false;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await _clearAuthPrefs(prefs);
    _currentUser = null;
    _needsProfileCompletion = false;
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
