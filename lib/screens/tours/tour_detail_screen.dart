import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/tour.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/detail_bottom_bar.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import 'tour_booking_screen.dart';

class TourDetailScreen extends StatelessWidget {
  final Tour tour;

  const TourDetailScreen({super.key, required this.tour});

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
                          Image.network(
                            tour.image ?? TravelImages.getTourImage(tour.hashCode),
                            fit: BoxFit.cover,
                            cacheWidth: 800,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return TravelImages.buildImageBackground(
                                imageUrl: TravelImages.getTourImage(tour.hashCode),
                                opacity: 0.3,
                                cacheWidth: 800,
                                child: const SizedBox.shrink(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return TravelImages.buildImageBackground(
                                imageUrl: TravelImages.getTourImage(tour.hashCode),
                                opacity: 0.5,
                                cacheWidth: 800,
                                child: const Center(
                                  child: Icon(Icons.image, size: 100, color: Colors.white70),
                                ),
                              );
                            },
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
                    if (tour.isTrending)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.categoryRed, AppTheme.categoryOrange],
                            ),
                            borderRadius: AppDesignSystem.borderRadiusSm,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.categoryRed.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text(AppLocalizations.of(context)!.hot, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
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
                    // ─── Above the fold: title, rating, price ──────────────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.title,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: AppDesignSystem.spacingMd),
                          RatingWidget(rating: tour.rating, reviewCount: tour.reviewCount),
                          const SizedBox(height: AppDesignSystem.spacingLg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.referencePrice,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  PriceWidget(
                                    price: tour.price,
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
                    const SizedBox(height: AppDesignSystem.spacingLg),
                    // ─── Description ───────────────────────────────────────
                    _sectionCard(
                      title: AppLocalizations.of(context)!.itineraryIntro,
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
                          tour.description,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacingLg),
                    // ─── Tour information ──────────────────────────────────
                    _sectionCard(
                      title: AppLocalizations.of(context)!.itineraryInfo,
                      child: Column(
                        children: [
                          _buildInfoRow('路线类型', tour.routeType, Icons.route, AppTheme.categoryBlue),
                          const SizedBox(height: AppDesignSystem.spacingMd),
                          _buildInfoRow('行程天数', '${tour.duration} 天', Icons.access_time, AppTheme.categoryOrange),
                          const SizedBox(height: AppDesignSystem.spacingMd),
                          _buildInfoRow('人数上限', '${tour.maxParticipants} 人', Icons.people, AppTheme.categoryPurple),
                          const SizedBox(height: AppDesignSystem.spacingMd),
                          _buildInfoRow(
                            '出发日期',
                            DateFormat('yyyy年MM月dd日').format(tour.startDate),
                            Icons.calendar_today,
                            AppTheme.categoryGreen,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacingLg),
                    _buildRouteSection(context, tour.route),
                    if (tour.packageDetails != null) ...[
                      const SizedBox(height: AppDesignSystem.spacingLg),
                      _buildPackageDetailsSection(context, tour.packageDetails!),
                    ],
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
              isFavorite: appProvider.isFavorite(tour.id),
              onFavoriteTap: () => appProvider.toggleFavorite(tour.id),
              price: tour.price,
              priceSuffix: AppLocalizations.of(context)!.priceFrom,
              primaryLabel: AppLocalizations.of(context)!.book,
              onPrimaryTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TourBookingScreen(tour: tour),
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

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppDesignSystem.borderRadiusSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppDesignSystem.borderRadiusSm,
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: AppDesignSystem.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection(BuildContext context, List<String> route) {
    return _sectionCard(
      title: AppLocalizations.of(context)!.itineraryRoute,
      child: Column(
        children: route.asMap().entries.map((entry) {
          final isLast = entry.key == route.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.categoryBlue, AppTheme.categoryCyan],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.categoryBlue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 32,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.categoryBlue.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppDesignSystem.spacingLg),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppDesignSystem.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: AppDesignSystem.borderRadiusSm,
                    border: Border.all(
                      color: AppTheme.categoryBlue.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPackageDetailsSection(BuildContext context, Map<String, dynamic> details) {
    return _sectionCard(
      title: AppLocalizations.of(context)!.packageDetails,
      child: Column(
        children: details.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDesignSystem.spacingMd),
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: AppDesignSystem.borderRadiusSm,
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 22),
                  const SizedBox(width: AppDesignSystem.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.value.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
