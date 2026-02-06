import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import '../utils/travel_images.dart';
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
      {
        'icon': Icons.home,
        'iconOutlined': Icons.home_outlined,
        'label': l10n.home,
        'image': TravelImages.getHomeHeader(0),
      },
      {
        'icon': Icons.people,
        'iconOutlined': Icons.people_outline,
        'label': l10n.companions,
        'image': TravelImages.getCompanionBackground(0),
      },
      {
        'icon': Icons.explore,
        'iconOutlined': Icons.explore_outlined,
        'label': l10n.tours,
        'image': TravelImages.getTourImage(0),
      },
      {
        'icon': Icons.hotel,
        'iconOutlined': Icons.hotel_outlined,
        'label': l10n.bookings,
        'image': TravelImages.getBookingBackground(0),
      },
      {
        'icon': Icons.article,
        'iconOutlined': Icons.article_outlined,
        'label': l10n.content,
        'image': TravelImages.getContentImage(0),
      },
      {
        'icon': Icons.person,
        'iconOutlined': Icons.person_outline,
        'label': l10n.profile,
        'image': TravelImages.getProfileBackground(0),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        child: TravelImages.buildImageBackground(
          imageUrl: TravelImages.getHomeHeader(5),
          opacity: 0.15,
          cacheWidth: 1200,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
            ),
            child: SafeArea(
              top: false,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    navItems.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _currentIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: _currentIndex == index
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor.withOpacity(0.2),
                                      AppTheme.primaryColor.withOpacity(0.1),
                                    ],
                                  )
                                : null,
                            boxShadow: _currentIndex == index
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index
                                      ? AppTheme.primaryColor.withOpacity(0.15)
                                      : Colors.transparent,
                                ),
                                child: Icon(
                                  _currentIndex == index
                                      ? navItems[index]['icon'] as IconData
                                      : navItems[index]['iconOutlined'] as IconData,
                                  color: _currentIndex == index
                                      ? AppTheme.primaryColor
                                      : Colors.grey.shade600,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  navItems[index]['label'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: _currentIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: _currentIndex == index
                                        ? AppTheme.primaryColor
                                        : Colors.grey.shade600,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
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
          ),
        ),
      ),
    );
  }
}



