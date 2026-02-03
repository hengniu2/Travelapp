import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import 'home/home_screen.dart';
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
    const HomeScreen(),
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
      bottomNavigationBar: _buildCustomBottomNav(context, l10n),
    );
  }

  Widget _buildCustomBottomNav(BuildContext context, AppLocalizations l10n) {
    final navItems = [
      {'icon': Icons.home, 'iconOutlined': Icons.home_outlined, 'label': l10n.home},
      {'icon': Icons.people, 'iconOutlined': Icons.people_outline, 'label': l10n.companions},
      {'icon': Icons.explore, 'iconOutlined': Icons.explore_outlined, 'label': l10n.tours},
      {'icon': Icons.hotel, 'iconOutlined': Icons.hotel_outlined, 'label': l10n.bookings},
      {'icon': Icons.article, 'iconOutlined': Icons.article_outlined, 'label': l10n.content},
      {'icon': Icons.person, 'iconOutlined': Icons.person_outline, 'label': l10n.profile},
    ];

    return Container(
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
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navItems.length,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentIndex == index
                              ? navItems[index]['icon'] as IconData
                              : navItems[index]['iconOutlined'] as IconData,
                          color: _currentIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade600,
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              navItems[index]['label'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: _currentIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: _currentIndex == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



