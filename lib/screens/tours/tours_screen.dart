import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/tour.dart';
import '../../widgets/price_widget.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import '../../utils/route_transitions.dart';
import '../../utils/tag_localizations.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/empty_state.dart';
import 'tour_detail_screen.dart';
import 'tour_filter_screen.dart';

// ─── Tours screen design constants (premium, Ctrip/Fliggy-style) ─────────────
const Color _pageBackground = Color(0xFFF7F8FA);
const Color _softGreenTint = Color(0xFFE8F5E9);
const double _headerHeight = 240.0;
const double _cardRadius = 16.0;
const double _cardElevation = 6.0;
const double _cardSpacing = 18.0;
const List<Color> _headerGradient = [
  Color(0xFF0D5C2E), // deep emerald
  Color(0xFF1B5E20),
  Color(0xFF2E7D32),
  Color(0xFF388E3C), // lighter green
];

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

  static const List<Map<String, dynamic>> _categories = [
    {'id': 'hot', 'icon': Icons.local_fire_department, 'label': '热门'},
    {'id': 'island', 'icon': Icons.beach_access, 'label': '海岛'},
    {'id': 'mountain', 'icon': Icons.terrain, 'label': '山川'},
    {'id': 'town', 'icon': Icons.account_balance, 'label': '古镇'},
    {'id': 'city', 'icon': Icons.location_city, 'label': '城市'},
  ];

  static const List<String> _destinations = [
    '西双版纳', '北京', '三亚', '丽江', '桂林', '成都', '哈尔滨', '重庆',
  ];

  int _selectedCategoryIndex = 0;
  int? _selectedDestinationIndex;

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

  String _categoryLabel(AppLocalizations l10n, String id) {
    switch (id) {
      case 'hot': return l10n.categoryHot;
      case 'island': return l10n.categoryIsland;
      case 'mountain': return l10n.categoryMountain;
      case 'town': return l10n.categoryTown;
      case 'city': return l10n.categoryCity;
      default: return id;
    }
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

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: _headerHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              TravelImages.getToursPageHeader(0),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _headerGradient,
                    stops: [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0D5C2E).withValues(alpha: 0.75),
                      const Color(0xFF1B5E20).withValues(alpha: 0.85),
                      const Color(0xFF2E7D32).withValues(alpha: 0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.toursTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Material(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDesignSystem.radiusMd),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white, size: 22),
                      onPressed: _showFilterDialog,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.toursSubtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchBar(context),
            ],
          ),
        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusXl),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: AppTheme.primaryColor),
                      const SizedBox(width: 10),
                      Text(
                        l10n.departShanghai,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 20, color: AppTheme.textTertiary),
                      const SizedBox(width: 10),
                      Text(
                        l10n.destinationKeywords,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textTertiary,
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
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = _selectedCategoryIndex == index;
          final label = _categoryLabel(l10n, cat['id'] as String);
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 72,
                decoration: BoxDecoration(
                  color: selected ? AppTheme.primaryColor : _softGreenTint,
                  borderRadius: BorderRadius.circular(AppDesignSystem.radiusXl),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 28,
                      color: selected ? Colors.white : AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinationChips(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.hotDepartureCities,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: List.generate(_destinations.length, (index) {
              final selected = _selectedDestinationIndex == index;
              final zhName = _destinations[index];
              final name = TagLocalizations.cityDisplayName(l10n.localeName, zhName);
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedDestinationIndex = _selectedDestinationIndex == index ? null : index;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        Divider(height: 1, color: Colors.grey.shade200, indent: 20, endIndent: 20),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.featuredRecommend,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.viewAll,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filteredTours.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index < _filteredTours.length - 1 ? _cardSpacing : 0),
                child: _FeaturedTourCard(
                  tour: _filteredTours[index],
                  index: index,
                  onTap: () => pushSlideUp(context, TourDetailScreen(tour: _filteredTours[index])),
                  routeTypeLabel: _routeTypeLabel,
                  l10n: l10n,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _pageBackground,
      body: _isLoading
          ? const SkeletonCardList(count: 5)
          : _filteredTours.isEmpty
              ? Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: EmptyState(
                        icon: Icons.explore_outlined,
                        headline: l10n.noToursFound,
                        subtitle: l10n.toursEmptySubtitle,
                        iconColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(context)),
                    SliverToBoxAdapter(child: _buildCategoryRow(context)),
                    SliverToBoxAdapter(child: _buildDestinationChips(context)),
                    SliverToBoxAdapter(child: _buildFeaturedSection(context)),
                  ],
                ),
    );
  }
}

class _FeaturedTourCard extends StatefulWidget {
  const _FeaturedTourCard({
    required this.tour,
    required this.index,
    required this.onTap,
    required this.routeTypeLabel,
    required this.l10n,
  });

  final Tour tour;
  final int index;
  final VoidCallback onTap;
  final String Function(String) routeTypeLabel;
  final AppLocalizations l10n;

  @override
  State<_FeaturedTourCard> createState() => _FeaturedTourCardState();
}

class _FeaturedTourCardState extends State<_FeaturedTourCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;
    final title = widget.l10n.localeName == 'zh' ? (tour.titleZh ?? tour.title) : tour.title;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: _cardElevation * 2,
                offset: Offset(0, _cardElevation),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_cardRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      TravelImages.buildImageBackground(
                        imageUrl: TravelImages.getSafeImageUrl(
                          tour.image,
                          widget.index,
                          1200,
                          675,
                        ),
                        opacity: 0.0,
                        cacheWidth: 1200,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '${tour.rating}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          Text(
                            widget.l10n.localeName == 'zh'
                                ? '${tour.reviewCount}人订'
                                : '${tour.reviewCount}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _smallChip(widget.routeTypeLabel(tour.routeType)),
                          _smallChip(
                            widget.l10n.localeName == 'zh' ? '${tour.duration}天' : '${tour.duration}d',
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
  }

  Widget _smallChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
