import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';
import '../../widgets/image_first_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import '../../l10n/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final favorites = appProvider.favorites;
    final dataService = DataService();

    if (favorites.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(l10n.favorites),
        ),
        body: EmptyState(
          icon: Icons.favorite_border,
          headline: l10n.noFavoritesYet,
          subtitle: l10n.favoritesEmptySubtitle,
          actionLabel: l10n.explore,
          onAction: () => Navigator.pop(context),
          iconColor: AppTheme.categoryPink,
        ),
      );
    }

    final companions = dataService.getCompanions();
    final tours = dataService.getTours();
    final hotels = dataService.getHotels();

    final favoriteItems = <Map<String, dynamic>>[];

    for (final id in favorites) {
      try {
        final companion = companions.firstWhere((c) => c.id == id);
        favoriteItems.add({
          'type': 'companion',
          'name': companion.name,
          'id': id,
        });
      } catch (e) {
        try {
          final tour = tours.firstWhere((t) => t.id == id);
          favoriteItems.add({
            'type': 'tour',
            'name': tour.title,
            'id': id,
          });
        } catch (e) {
          try {
            final hotel = hotels.firstWhere((h) => h.id == id);
            favoriteItems.add({
              'type': 'hotel',
              'name': hotel.name,
              'id': id,
            });
          } catch (_) {
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.favorites),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];
          final type = item['type'] as String;
          final name = item['name'] as String;
          final id = item['id'] as String;
          String imageUrl;
          if (type == 'companion') {
            imageUrl = TravelImages.getCompanionBackground(index);
          } else if (type == 'tour') {
            imageUrl = TravelImages.getTourImage(index);
          } else {
            imageUrl = TravelImages.getHotelImage(index);
          }
          return ImageFirstCard(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppDesignSystem.radiusImage)),
                      child: SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: TravelImages.buildImageBackground(
                          imageUrl: imageUrl,
                          opacity: 0.0,
                          cacheWidth: 600,
                          child: const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppDesignSystem.spacingMd,
                      right: AppDesignSystem.spacingMd,
                      child: CardBadge(
                        label: type.toUpperCase(),
                        color: AppTheme.primaryColor,
                        icon: _getIcon(type),
                      ),
                    ),
                    Positioned(
                      top: AppDesignSystem.spacingMd,
                      left: AppDesignSystem.spacingMd,
                      child: Material(
                        color: Colors.black54,
                        borderRadius: AppDesignSystem.borderRadiusSm,
                        child: InkWell(
                          onTap: () => appProvider.toggleFavorite(id),
                          borderRadius: AppDesignSystem.borderRadiusSm,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.favorite,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => appProvider.toggleFavorite(id),
                        icon: const Icon(Icons.favorite, color: AppTheme.categoryRed, size: 20),
                        label: Text(l10n.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'companion':
        return Icons.people;
      case 'tour':
        return Icons.explore;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.star;
    }
  }
}

