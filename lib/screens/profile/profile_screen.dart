import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import 'orders_screen.dart';
import 'favorites_screen.dart';
import 'reviews_screen.dart';
import 'wallet_screen.dart';
import 'notifications_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Widget _avatarPlaceholder(User? user) {
    final initial = (user?.name != null && user!.name.trim().isNotEmpty)
        ? user.name[0].toUpperCase()
        : 'U';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: AppTheme.primaryGradient),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: TravelImages.buildImageBackground(
        imageUrl: TravelImages.getProfileBackground(5),
        opacity: 0.1,
        cacheWidth: 1200,
        child: Container(
          color: AppTheme.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
            SizedBox(
              width: double.infinity,
              child: TravelImages.buildImageBackground(
                imageUrl: TravelImages.getProfileBackground(0),
                opacity: 0.8,
                cacheWidth: 800,
                child: Container(
                padding: const EdgeInsets.only(top: 40, bottom: 40, left: 24, right: 24),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.white.withOpacity(0.9)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.transparent,
                    child: (user?.avatar != null && user!.avatar!.trim().isNotEmpty)
                              ? ClipOval(
                                  child: Image.network(
                                    user.avatar!,
                                    width: 92,
                                    height: 92,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _avatarPlaceholder(user),
                                  ),
                                )
                              : _avatarPlaceholder(user),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user?.name ?? l10n.guest,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: AppDesignSystem.borderRadiusImage,
                    ),
                    child: Text(
                    user?.email ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ),
            ),
            _buildMenuItem(
              context,
              l10n.editProfile,
              Icons.edit,
              AppTheme.primaryColor,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              l10n.orders,
              Icons.shopping_bag,
              AppTheme.categoryBlue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrdersScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              l10n.favorites,
              Icons.favorite,
              AppTheme.categoryPink,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritesScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              l10n.reviews,
              Icons.rate_review,
              AppTheme.categoryOrange,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReviewsScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              l10n.wallet,
              Icons.account_balance_wallet,
              AppTheme.categoryGreen,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WalletScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              l10n.notifications,
              Icons.notifications,
              AppTheme.categoryPurple,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              AppLocalizations.of(context)!.language,
              Icons.language,
              AppTheme.categoryCyan,
              () {
                _showLanguageDialog(context);
              },
            ),
            _buildMenuItem(
              context,
              AppLocalizations.of(context)!.logout,
              Icons.logout,
              AppTheme.categoryRed,
              () {
                _showLogoutConfirm(context);
              },
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              appProvider.logout();
            },
            child: Text(l10n.logout, style: const TextStyle(color: AppTheme.categoryRed)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text(l10n.english),
              value: const Locale('en'),
              groupValue: appProvider.locale,
              onChanged: (Locale? value) {
                if (value != null) {
                  appProvider.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.chinese),
              value: const Locale('zh'),
              groupValue: appProvider.locale,
              onChanged: (Locale? value) {
                if (value != null) {
                  appProvider.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    Color menuColor,
    VoidCallback onTap,
  ) {
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDesignSystem.borderRadiusImage,
        boxShadow: [
          BoxShadow(
            color: menuColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
      onTap: onTap,
          borderRadius: AppDesignSystem.borderRadiusImage,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        menuColor,
                        menuColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: AppDesignSystem.borderRadiusImage,
                    boxShadow: [
                      BoxShadow(
                        color: menuColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: menuColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

