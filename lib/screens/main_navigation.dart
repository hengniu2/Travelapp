import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import '../utils/app_design_system.dart';
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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(context, l10n),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppLocalizations l10n) {
    const double iconSize = 24;
    const double labelSize = 11;
    final navItems = [
      (icon: Icons.home_rounded, iconOut: Icons.home_outlined, label: l10n.home),
      (icon: Icons.people_rounded, iconOut: Icons.people_outline_rounded, label: l10n.companions),
      (icon: Icons.explore_rounded, iconOut: Icons.explore_outlined, label: l10n.tours),
      (icon: Icons.hotel_rounded, iconOut: Icons.hotel_outlined, label: l10n.bookings),
      (icon: Icons.article_rounded, iconOut: Icons.article_outlined, label: l10n.content),
      (icon: Icons.person_rounded, iconOut: Icons.person_outline_rounded, label: l10n.profile),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spacingSm,
            vertical: AppDesignSystem.spacingSm,
          ),
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                navItems.length,
                (index) {
                  final item = navItems[index];
                  final selected = _currentIndex == index;
                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _currentIndex = index),
                        borderRadius: AppDesignSystem.borderRadiusMd,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                selected ? item.icon : item.iconOut,
                                size: iconSize,
                                color: selected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textTertiary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: labelSize,
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                  color: selected
                                      ? AppTheme.primaryColor
                                      : AppTheme.textTertiary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
