import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/tour.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/image_first_card.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import '../../utils/route_transitions.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/empty_state.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTours();
  }

  Future<void> _loadTours() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _tours = _dataService.getTours();
      _isLoading = false;
    });
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDesignSystem.borderRadiusImage,
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: AppDesignSystem.borderRadiusImage,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF1B5E20),
            Color(0xFF388E3C),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: ClipRRect(
        borderRadius: AppDesignSystem.borderRadiusImage,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.explore, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    '跟团游',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: AppDesignSystem.borderRadiusImage,
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
          final color = cat['color'] as Color;
          return Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: AppDesignSystem.borderRadiusImage,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    cat['icon'] as IconData,
                    color: Colors.white,
                    size: 32,
                  ),
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
              borderRadius: AppDesignSystem.borderRadiusImage,
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

  String _routeTypeLabel(String routeType) {
    final l10n = AppLocalizations.of(context)!;
    if (l10n.localeName == 'zh') {
      switch (routeType) {
        case 'Multi-City': return '多城连线';
        case 'City Tour': return '城市游';
        case 'Cruise': return '邮轮';
        default: return routeType;
      }
    }
    return routeType;
  }

  Widget _buildTourCard(Tour tour, int index) {
    final isHot = tour.isTrending;
    final isRecommended = tour.rating >= 4.5;
    final isPurePlay = tour.routeType == 'Multi-City' || tour.routeType == 'City Tour';
    final l10n = AppLocalizations.of(context)!;
    final title = l10n.localeName == 'zh' ? (tour.titleZh ?? tour.title) : tour.title;
    final descriptionSnippet = tour.description.length > 48
        ? '${tour.description.substring(0, 48)}...'
        : tour.description;

    return ImageFirstCard(
      onTap: () {
        pushSlideUp(context, TourDetailScreen(tour: tour));
      },
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    TravelImages.buildImageBackground(
                      imageUrl: TravelImages.getSafeImageUrl(tour.image, index, 1200, 675),
                      opacity: 0.0,
                      cacheWidth: 1200,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppDesignSystem.spacingMd,
                      right: AppDesignSystem.spacingMd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (isHot)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: CardBadge(
                                label: l10n.hot,
                                color: AppTheme.categoryRed,
                                icon: Icons.local_fire_department,
                              ),
                            ),
                          if (isPurePlay)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: CardBadge(
                                label: l10n.purePlay,
                                color: AppTheme.categoryOrange,
                              ),
                            ),
                          if (isRecommended)
                            CardBadge(
                              label: l10n.recommend,
                              color: AppTheme.primaryColor,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppDesignSystem.spacingLg, AppDesignSystem.spacingMd, AppDesignSystem.spacingLg, AppDesignSystem.spacingSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      descriptionSnippet,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _smallTag(_routeTypeLabel(tour.routeType), AppTheme.primaryColor),
                        _smallTag(l10n.localeName == 'zh' ? '${tour.duration}天' : '${tour.duration}d', AppTheme.categoryOrange),
                        _smallTag(l10n.localeName == 'zh' ? '共${tour.reviewCount}人预订' : '${tour.reviewCount} booked', AppTheme.textSecondary),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PriceWidget(
                          price: tour.price,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        RatingWidget(
                          rating: tour.rating,
                          reviewCount: tour.reviewCount,
                          size: 14,
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

  Widget _smallTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: TravelImages.buildImageBackground(
        imageUrl: TravelImages.getTourImage(10),
        opacity: 0.08,
        cacheWidth: 1200,
        child: Container(
          color: AppTheme.backgroundColor,
          child: _isLoading
              ? const SkeletonCardList(count: 5)
              : _filteredTours.isEmpty
                  ? EmptyState(
                      icon: Icons.explore_outlined,
                      headline: l10n.noToursFound,
                      subtitle: l10n.toursEmptySubtitle,
                      iconColor: AppTheme.primaryColor,
                    )
                  : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 0,
                      floating: true,
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: Stack(
                        fit: StackFit.expand,
                        children: [
                          TravelImages.buildImageBackground(
                            imageUrl: TravelImages.getToursPageHeader(0),
                            opacity: 0.35,
                            cacheWidth: 800,
                            child: Container(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.78),
                                  Colors.white.withOpacity(0.88),
                                ],
                              ),
                            ),
                            child: SafeArea(
                              bottom: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.tourGroups,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.filter_list, color: AppTheme.primaryColor),
                                            onPressed: _showFilterDialog,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchBar(),
                          _buildHeroBanner(),
                          _buildCategoryIcons(),
                          _buildPopularDestinations(),
                          const SizedBox(height: 20),
                          // Featured Tours Section
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '精选推荐',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        '查看更多 >',
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 420,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _filteredTours.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 16),
                                        width: 320,
                                        child: InkWell(
                                          onTap: () {
                                            pushSlideUp(
                                              context,
                                              TourDetailScreen(tour: _filteredTours[index]),
                                            );
                                          },
                                          child: _buildTourCard(_filteredTours[index], index),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}



