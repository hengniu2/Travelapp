import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/detail_bottom_bar.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import 'hotel_booking_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ─── Large header image ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 380,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          TravelImages.buildImageBackground(
                            imageUrl: TravelImages.getSafeImageUrl(
                              hotel.image,
                              hotel.hashCode,
                              800,
                              600,
                            ),
                            opacity: 0.0,
                            cacheWidth: 800,
                            child: const SizedBox.shrink(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 8,
                      child: Material(
                        color: Colors.black45,
                        borderRadius: AppDesignSystem.borderRadiusImage,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: AppDesignSystem.borderRadiusImage,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppDesignSystem.spacingLg, 0, AppDesignSystem.spacingLg, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ─── Above the fold: name, location, rating, price ──────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.name,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: AppDesignSystem.spacingMd),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 20, color: AppTheme.categoryBlue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  hotel.location,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDesignSystem.spacingMd),
                          RatingWidget(
                            rating: hotel.rating,
                            reviewCount: hotel.reviewCount,
                          ),
                          const SizedBox(height: AppDesignSystem.spacingLg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.referencePriceLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  PriceWidget(
                                    price: hotel.pricePerNight,
                                    prefix: '¥',
                                    showFrom: false,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.categoryRed,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (hotel.description != null && hotel.description!.isNotEmpty) ...[
                      const SizedBox(height: AppDesignSystem.spacingLg),
                      _sectionCard(
                        title: AppLocalizations.of(context)!.hotelIntro,
                        child: Container(
                          padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.06),
                            borderRadius: AppDesignSystem.borderRadiusSm,
                            border: Border.all(
                              color: AppTheme.primaryColor.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            hotel.description!,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDesignSystem.spacingLg),
                    _sectionCard(
                      title: AppLocalizations.of(context)!.facilities,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: hotel.amenities
                            .map((amenity) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.categoryBlue.withValues(alpha: 0.12),
                                    borderRadius: AppDesignSystem.borderRadiusSm,
                                    border: Border.all(
                                      color: AppTheme.categoryBlue.withValues(alpha: 0.25),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle,
                                          size: 18, color: AppTheme.categoryBlue),
                                      const SizedBox(width: 6),
                                      Text(
                                        amenity,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.categoryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacingXxl),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DetailBottomBar(
              showFavorite: true,
              isFavorite: appProvider.isFavorite(hotel.id),
              onFavoriteTap: () => appProvider.toggleFavorite(hotel.id),
              price: hotel.pricePerNight,
              priceSuffix: AppLocalizations.of(context)!.perNight,
              primaryLabel: AppLocalizations.of(context)!.book,
              onPrimaryTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelBookingScreen(hotel: hotel),
                  ),
                );
              },
              primaryEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesignSystem.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppDesignSystem.borderRadiusXl,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesignSystem.spacingLg),
          ],
          child,
        ],
      ),
    );
  }
}
