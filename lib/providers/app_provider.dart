import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order.dart';

class AppProvider with ChangeNotifier {
  User? _currentUser;
  final List<Order> _orders = [];
  final List<String> _favorites = [];
  double _walletBalance = 0.0;
  Locale _locale = const Locale('zh');

  User? get currentUser => _currentUser;
  List<Order> get orders => _orders;
  List<String> get favorites => _favorites;
  double get walletBalance => _walletBalance;
  Locale get locale => _locale;

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
    _currentUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
    );
    _walletBalance = 500.0;
    
    // Load saved language preference (default: Chinese)
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code');
    _locale = Locale(savedLanguage ?? 'zh');
    
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

