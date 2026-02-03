import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import 'companions/companions_screen.dart';
import 'tours/tours_screen.dart';
import 'bookings/bookings_screen.dart';
import 'content/content_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CompanionsScreen(),
    const ToursScreen(),
    const BookingsScreen(),
    const ContentScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppTheme.backgroundColor.withOpacity(0.3),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, -3),
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey.shade600,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          elevation: 0,
          backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: l10n.companions,
          ),
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 1 ? Icons.explore : Icons.explore_outlined),
            label: l10n.tours,
          ),
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 2 ? Icons.hotel : Icons.hotel_outlined),
            label: l10n.bookings,
          ),
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 3 ? Icons.favorite : Icons.favorite_border),
            label: l10n.content,
          ),
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 4 ? Icons.person : Icons.person_outline),
            label: l10n.profile,
          ),
        ],
        ),
      ),
    );
  }
}



