import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/hotel.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/image_first_card.dart';
import '../../widgets/ios_bottom_sheet.dart';
import '../../widgets/empty_state.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import '../../utils/route_transitions.dart';
import 'hotel_detail_screen.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final DataService _dataService = DataService();
  List<Hotel> _hotels = [];
  List<Hotel> _filteredHotels = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadHotels() {
    _hotels = _dataService.getHotels();
    _filteredHotels = _hotels;
  }

  void _searchHotels(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHotels = _hotels;
      } else {
        _filteredHotels = _hotels.where((hotel) {
          return hotel.name.toLowerCase().contains(query.toLowerCase()) ||
              hotel.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showSortDialog() {
    final l10n = AppLocalizations.of(context)!;
    showIosActionSheet(
      context,
      title: l10n.sortHotels,
      cancelLabel: l10n.cancel,
      actions: [
        IosSheetAction(
          icon: Icons.arrow_upward,
          label: l10n.priceLowToHigh,
          onTap: () => setState(() {
            _filteredHotels.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
          }),
          color: AppTheme.categoryGreen,
        ),
        IosSheetAction(
          icon: Icons.arrow_downward,
          label: l10n.priceHighToLow,
          onTap: () => setState(() {
            _filteredHotels.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
          }),
          color: AppTheme.categoryGreen,
        ),
        IosSheetAction(
          icon: Icons.star,
          label: l10n.ratingHighToLow,
          onTap: () => setState(() {
            _filteredHotels.sort((a, b) => b.rating.compareTo(a.rating));
          }),
          color: AppTheme.categoryOrange,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.hotels),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar with gradient
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.95)],
              ),
              borderRadius: AppDesignSystem.borderRadiusImage,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHotels,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppTheme.primaryGradient),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 20),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: AppTheme.primaryColor),
                        onPressed: () {
                          _searchController.clear();
                          _searchHotels('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: AppDesignSystem.borderRadiusImage,
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: _searchHotels,
            ),
          ),
          Expanded(
            child: _filteredHotels.isEmpty
                ? EmptyState(
                    icon: Icons.hotel_outlined,
                    headline: l10n.noHotelsFound,
                    subtitle: l10n.tryOtherKeywords,
                    iconColor: AppTheme.categoryBlue,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
                    itemCount: _filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _filteredHotels[index];
                      return ImageFirstCard(
                        onTap: () {
                          pushSlideUp(context, HotelDetailScreen(hotel: hotel));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(AppDesignSystem.radiusImage)),
                              child: SizedBox(
                                height: 180,
                                width: double.infinity,
                                child: TravelImages.buildImageBackground(
                                  imageUrl: TravelImages.getSafeImageUrl(
                                    hotel.image,
                                    hotel.hashCode,
                                    600,
                                    400,
                                  ),
                                  opacity: 0.0,
                                  cacheWidth: 600,
                                  child: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: AppDesignSystem.spacingSm),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 16, color: AppTheme.categoryBlue),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          hotel.location,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.categoryBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppDesignSystem.spacingSm),
                                  RatingWidget(
                                    rating: hotel.rating,
                                    reviewCount: hotel.reviewCount,
                                  ),
                                  const SizedBox(height: AppDesignSystem.spacingMd),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: hotel.amenities
                                        .take(3)
                                        .map((amenity) => Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppTheme.categoryGreen
                                                    .withOpacity(0.12),
                                                borderRadius:
                                                    AppDesignSystem.borderRadiusSm,
                                                border: Border.all(
                                                  color: AppTheme.categoryGreen
                                                      .withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                amenity,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: AppTheme.categoryGreen,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: AppDesignSystem.spacingMd),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PriceWidget(
                                        price: hotel.pricePerNight,
                                        prefix: '¥',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.categoryRed,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 16, color: AppTheme.primaryColor),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}



