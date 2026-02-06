import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/hotel.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../utils/app_theme.dart';
import '../../utils/travel_images.dart';
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
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sortHotels),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.priceLowToHigh),
              onTap: () {
                setState(() {
                  _filteredHotels.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.priceHighToLow),
              onTap: () {
                setState(() {
                  _filteredHotels.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.ratingHighToLow),
              onTap: () {
                setState(() {
                  _filteredHotels.sort((a, b) => b.rating.compareTo(a.rating));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
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
              borderRadius: BorderRadius.circular(20),
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
                  borderRadius: BorderRadius.circular(20),
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: TravelImages.buildImageBackground(
                              imageUrl: TravelImages.getHotelImage(0),
                              opacity: 0.3,
                              cacheWidth: 300,
                              child: Center(
                                child: Icon(
                                  Icons.hotel_outlined,
                                  size: 64,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noHotelsFound,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _filteredHotels[index];
                      final gradient = TravelImages.getGradientForIndex(hotel.hashCode);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.categoryBlue.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HotelDetailScreen(hotel: hotel),
                              ),
                            );
                          },
                            borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  // Hotel image
                                Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.categoryBlue.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: TravelImages.buildImageBackground(
                                        imageUrl: TravelImages.getSafeImageUrl(
                                          hotel.image, 
                                          hotel.hashCode, 
                                          300, 
                                          300
                                        ),
                                        opacity: 0.3,
                                        cacheWidth: 300,
                                        child: const SizedBox.shrink(),
                                      ),
                                    ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
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
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.categoryBlue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                        children: [
                                              Icon(Icons.location_on, size: 16, color: AppTheme.categoryBlue),
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
                                        ),
                                        const SizedBox(height: 10),
                                      RatingWidget(
                                        rating: hotel.rating,
                                        reviewCount: hotel.reviewCount,
                                      ),
                                        const SizedBox(height: 10),
                                      Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                        children: hotel.amenities
                                            .take(3)
                                              .map((amenity) => Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppTheme.categoryGreen.withOpacity(0.15),
                                                          AppTheme.categoryGreen.withOpacity(0.08),
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: AppTheme.categoryGreen.withOpacity(0.3),
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
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: AppTheme.primaryGradient),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                      ),
                                    ],
                                  ),
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
        ],
      ),
    );
  }
}



