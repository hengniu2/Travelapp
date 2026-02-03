import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/tour.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../utils/app_theme.dart';
import '../../utils/travel_images.dart';
import 'tour_detail_screen.dart';
import 'tour_filter_screen.dart';

// Decorative pattern painter for image placeholders
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Draw diagonal lines
    for (int i = 0; i < 20; i++) {
      canvas.drawLine(
        Offset(i * 30.0, 0),
        Offset(i * 30.0 + size.height, size.height),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  final DataService _dataService = DataService();
  List<Tour> _tours = [];
  List<Tour> _filteredTours = [];
  String _filterType = 'All';
  String _sortBy = 'Trending';

  @override
  void initState() {
    super.initState();
    _loadTours();
  }

  void _loadTours() {
    _tours = _dataService.getTours();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredTours = _tours.where((tour) {
        return _filterType == 'All' || tour.routeType == _filterType;
      }).toList();

      if (_sortBy == 'Trending') {
        _filteredTours.sort((a, b) => b.isTrending ? 1 : -1);
      } else if (_sortBy == 'Price Low') {
        _filteredTours.sort((a, b) => a.price.compareTo(b.price));
      } else if (_sortBy == 'Price High') {
        _filteredTours.sort((a, b) => b.price.compareTo(a.price));
      } else if (_sortBy == 'Duration') {
        _filteredTours.sort((a, b) => a.duration.compareTo(b.duration));
      }
    });
  }

  Future<void> _showFilterDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourFilterScreen(
          selectedType: _filterType,
          selectedSort: _sortBy,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _filterType = result['type'] ?? 'All';
        _sortBy = result['sort'] ?? 'Trending';
      });
      _applyFilters();
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Handle location selection
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '上海出发',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 2,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Expanded(
                  child: InkWell(
                    onTap: () {
                // Handle search
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppTheme.categoryOrange, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      '目的地/关键词',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.explore, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '跟团游',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '省时省心,"吃住行玩"一站式打包',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcons() {
    final categories = [
      {'icon': Icons.local_fire_department, 'label': '热门', 'color': AppTheme.categoryRed, 'gradient': [AppTheme.categoryRed, const Color(0xFFFF6B6B)]},
      {'icon': Icons.business, 'label': '海南/福建', 'color': AppTheme.categoryGreen, 'gradient': [AppTheme.categoryGreen, const Color(0xFF4DD865)]},
      {'icon': Icons.landscape, 'label': '云贵川', 'color': AppTheme.categoryOrange, 'gradient': [AppTheme.categoryOrange, const Color(0xFFFFB74D)]},
      {'icon': Icons.terrain, 'label': '广西/湖南', 'color': AppTheme.categoryCyan, 'gradient': [AppTheme.categoryCyan, const Color(0xFF4DD0E1)]},
      {'icon': Icons.location_city, 'label': '北京/陕西', 'color': AppTheme.categoryPurple, 'gradient': [AppTheme.categoryPurple, AppTheme.categoryPink]},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((cat) {
          final gradient = cat['gradient'] as List<Color>;
          return Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: (cat['color'] as Color).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  cat['icon'] as IconData,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                cat['label'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopularDestinations() {
    final destinations = [
      {'name': '西双版纳', 'color': AppTheme.categoryGreen},
      {'name': '北京', 'color': AppTheme.categoryRed},
      {'name': '三亚', 'color': AppTheme.categoryBlue},
      {'name': '丽江', 'color': AppTheme.categoryPurple},
      {'name': '桂林', 'color': AppTheme.categoryCyan},
      {'name': '成都', 'color': AppTheme.categoryOrange},
      {'name': '哈尔滨', 'color': AppTheme.categoryPink},
      {'name': '重庆', 'color': AppTheme.categoryYellow},
    ];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: destinations.map((dest) {
          final color = dest['color'] as Color;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
              ),
              borderRadius: BorderRadius.circular(24),
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
                Icon(Icons.place, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  dest['name'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
                        ),
                      );
        }).toList(),
      ),
    );
  }

  Widget _buildTourCard(Tour tour, int index) {
    final gradients = [
      AppTheme.primaryGradient,
      AppTheme.sunsetGradient,
      AppTheme.oceanGradient,
      AppTheme.purpleGradient,
    ];
    final gradient = gradients[index % gradients.length];
    
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                  ),
                  child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          tour.image ?? TravelImages.getTourImage(index),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: gradient,
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: gradient,
                                ),
                              ),
                              child: const Icon(Icons.image, size: 70, color: Colors.white70),
                            );
                          },
                        ),
                            // Overlay gradient for better text readability
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              // Booking count badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '共${tour.reviewCount}人预订',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                            ),
                    ],
                  ),
                ),
              ),
              // Trending badge
                            if (tour.isTrending)
                              Positioned(
                  top: 12,
                  right: 12,
                                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.categoryRed, AppTheme.categoryOrange],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.categoryRed.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          '热门',
                          style: TextStyle(
                                      color: Colors.white,
                            fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                        ),
                      ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tour.title,
                  style: TextStyle(
                    fontSize: 16,
                                  fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: AppTheme.textPrimary,
                              ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.15),
                            AppTheme.primaryColor.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                                children: [
                          Icon(Icons.shopping_cart_outlined, size: 12, color: AppTheme.primaryColor),
                                  const SizedBox(width: 4),
                          Text(
                            '0购物',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentColor.withOpacity(0.15),
                            AppTheme.accentColor.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                                children: [
                          Icon(Icons.verified, size: 12, color: AppTheme.accentColor),
                                  const SizedBox(width: 4),
                          Text(
                            '成团保障',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                                ],
                              ),
                const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                    PriceWidget(price: tour.price),
                                  RatingWidget(
                                    rating: tour.rating,
                                    reviewCount: tour.reviewCount,
                                  ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.tourGroups),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: _filteredTours.isEmpty
          ? Center(
              child: Text(
                l10n.noToursFound,
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  _buildHeroBanner(),
                  _buildCategoryIcons(),
                  _buildPopularDestinations(),
                  const SizedBox(height: 16),
                  // Featured Tours Section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '精选推荐',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                '查看更多 >',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                                ],
                              ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 320,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filteredTours.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TourDetailScreen(tour: _filteredTours[index]),
                                    ),
                                  );
                                },
                                child: _buildTourCard(_filteredTours[index], index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}



