import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/companion.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import 'companion_chat_screen.dart';
import 'companion_booking_screen.dart';

class CompanionDetailScreen extends StatelessWidget {
  final Companion companion;

  const CompanionDetailScreen({super.key, required this.companion});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    final gradients = [
      [const Color(0xFF00C853), const Color(0xFF4DD865)],
      [const Color(0xFFFF6B35), const Color(0xFFFFB74D)],
      [const Color(0xFF2979FF), const Color(0xFF00E5FF)],
      [const Color(0xFFAA00FF), const Color(0xFFFF4081)],
    ];
    final gradient = gradients[companion.hashCode % gradients.length];

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompanionChatScreen(companion: companion),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            l10n.chat,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: companion.isAvailable
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CompanionBookingScreen(companion: companion),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.book_online, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            l10n.bookNow,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TravelImages.buildImageBackground(
        imageUrl: TravelImages.getCompanionBackground(companion.hashCode % 10),
        opacity: 0.04,
        cacheWidth: 1200,
        child: Container(
          color: AppTheme.backgroundColor,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      TravelImages.buildImageBackground(
                        imageUrl: TravelImages.getCompanionBackground(companion.hashCode % 10),
                        opacity: 0.5,
                        cacheWidth: 1200,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Profile avatar overlay
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: TravelImages.buildImageBackground(
                                  imageUrl: TravelImages.getSafeImageUrl(
                                    companion.avatar,
                                    companion.hashCode,
                                    400,
                                    400,
                                  ),
                                  opacity: 0.0,
                                  cacheWidth: 400,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: gradient),
                                    ),
                                    child: Center(
                                      child: Text(
                                        companion.name[0],
                                        style: const TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    companion.name,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black54,
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RatingWidget(
                                    rating: companion.rating,
                                    reviewCount: companion.reviewCount,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        appProvider.isFavorite(companion.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        appProvider.toggleFavorite(companion.id);
                      },
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Availability and stats bar
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          Icons.check_circle,
                          companion.isAvailable ? '在线' : '离线',
                          companion.isAvailable ? const Color(0xFF4CAF50) : Colors.grey,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatCard(
                          Icons.star,
                          '${companion.rating}分',
                          AppTheme.categoryOrange,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatCard(
                          Icons.people,
                          '${companion.reviewCount}评价',
                          AppTheme.categoryBlue,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (companion.bio != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryColor.withOpacity(0.1),
                                  AppTheme.primaryColor.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              companion.bio!,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        _buildSection(
                          l10n.destinations,
                          companion.destinations,
                          Icons.location_on,
                          AppTheme.categoryBlue,
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          l10n.interests,
                          companion.interests,
                          Icons.favorite,
                          AppTheme.categoryPink,
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          l10n.skills,
                          companion.skills,
                          Icons.star,
                          AppTheme.categoryOrange,
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          l10n.languages,
                          companion.languages,
                          Icons.language,
                          AppTheme.categoryPurple,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppTheme.primaryGradient,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.pricePerDay,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  PriceWidget(
                                    price: companion.pricePerDay,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map((item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.15),
                          color.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16, color: color),
                        const SizedBox(width: 6),
                        Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
