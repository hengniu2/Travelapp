import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../services/data_service.dart';
import '../../models/tour.dart';
import '../../models/companion.dart';
import '../../models/content.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../companions/companions_screen.dart';
import '../tours/tours_screen.dart';
import '../bookings/bookings_screen.dart';
import '../content/content_screen.dart';
import '../tours/tour_detail_screen.dart';
import '../companions/companion_detail_screen.dart';
import '../content/content_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService _dataService = DataService();
  final PageController _heroPageController = PageController();
  List<Tour> _hotTours = [];
  List<Companion> _recommendCompanions = [];
  List<Tour> _topTours = [];
  List<TravelContent> _trendingContent = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _heroPageController.dispose();
    super.dispose();
  }

  void _loadData() {
    final tours = _dataService.getTours();
    final companions = _dataService.getCompanions();
    final content = _dataService.getTravelContent();
    setState(() {
      _hotTours = tours.where((t) => t.isTrending).toList();
      if (_hotTours.length < 4) _hotTours = tours.take(4).toList();
      _recommendCompanions = companions.where((c) => c.isAvailable).take(4).toList();
      _topTours = tours.take(3).toList();
      _trendingContent = content.take(2).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadData(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeroCarousel()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildCategoryGrid()),
              SliverToBoxAdapter(child: _buildPillTags()),
              SliverToBoxAdapter(child: _buildSectionHot()),
              SliverToBoxAdapter(child: _buildSectionRecommend()),
              SliverToBoxAdapter(child: _buildSectionTop()),
              SliverToBoxAdapter(child: _buildSectionContent()),
              const SliverToBoxAdapter(child: SizedBox(height: AppDesignSystem.spacingXxl)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCarousel() {
    const count = 3;
    return Container(
      height: 180,
      margin: const EdgeInsets.only(
        left: AppDesignSystem.spacingLg,
        right: AppDesignSystem.spacingLg,
        top: AppDesignSystem.spacingSm,
      ),
      decoration: BoxDecoration(
        borderRadius: AppDesignSystem.borderRadiusImage,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppDesignSystem.borderRadiusImage,
        child: PageView.builder(
          controller: _heroPageController,
          itemCount: count,
          itemBuilder: (context, index) {
            return TravelImages.buildImageBackground(
              imageUrl: TravelImages.getHomeHeader(index),
              opacity: 0.5,
              cacheWidth: 800,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.25),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDesignSystem.spacingLg,
        AppDesignSystem.spacingLg,
        AppDesignSystem.spacingLg,
        AppDesignSystem.spacingMd,
      ),
      child: Material(
        elevation: AppDesignSystem.elevationCard,
        shadowColor: AppTheme.shadowColor,
        borderRadius: AppDesignSystem.borderRadiusLg,
        color: AppTheme.surfaceColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ToursScreen()),
            );
          },
          borderRadius: AppDesignSystem.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spacingLg,
              vertical: AppDesignSystem.spacingMd,
            ),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 20, color: AppTheme.primaryColor),
                const SizedBox(width: AppDesignSystem.spacingSm),
                Text(
                  l10n.departFrom,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: AppDesignSystem.spacingSm),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: AppDesignSystem.spacingLg),
                Icon(Icons.search_rounded, size: 22, color: AppTheme.textTertiary),
                const SizedBox(width: AppDesignSystem.spacingSm),
                Expanded(
                  child: Text(
                    l10n.destinationKeywords,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final l10n = AppLocalizations.of(context)!;
    final categories = [
      (icon: Icons.local_fire_department_rounded, label: l10n.trending, color: AppTheme.categoryOrange, onTap: () => _goToTours()),
      (icon: Icons.people_rounded, label: l10n.companions, color: AppTheme.categoryBlue, onTap: () => _goToCompanions()),
      (icon: Icons.explore_rounded, label: l10n.tours, color: AppTheme.categoryGreen, onTap: () => _goToTours()),
      (icon: Icons.hotel_rounded, label: l10n.hotels, color: AppTheme.categoryCyan, onTap: () => _goToBookings()),
      (icon: Icons.article_rounded, label: l10n.content, color: AppTheme.categoryPurple, onTap: () => _goToContent()),
      (icon: Icons.thumb_up_rounded, label: l10n.recommend, color: AppTheme.categoryPink, onTap: () => _goToCompanions()),
      (icon: Icons.place_rounded, label: l10n.destinations, color: AppTheme.categoryYellow, onTap: () => _goToTours()),
      (icon: Icons.apps_rounded, label: l10n.all, color: AppTheme.textSecondary, onTap: () => _goToTours()),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
      child: Column(
        children: [
          Row(
            children: List.generate(4, (col) => Expanded(
              child: _categoryItem(
                icon: categories[col].icon,
                label: categories[col].label,
                color: categories[col].color,
                onTap: categories[col].onTap,
              ),
            )),
          ),
          const SizedBox(height: AppDesignSystem.spacingMd),
          Row(
            children: List.generate(4, (col) => Expanded(
              child: _categoryItem(
                icon: categories[col + 4].icon,
                label: categories[col + 4].label,
                color: categories[col + 4].color,
                onTap: categories[col + 4].onTap,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _categoryItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingXs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDesignSystem.borderRadiusMd,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppDesignSystem.spacingSm),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDesignSystem.spacingSm),
            ],
          ),
        ),
      ),
    );
  }

  void _goToTours() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ToursScreen()));
  void _goToCompanions() => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanionsScreen()));
  void _goToBookings() => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingsScreen()));
  void _goToContent() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContentScreen()));

  Widget _buildPillTags() {
    final tags = ['北京', '三亚', '上海', '成都', '西安', '云南', '桂林', '杭州'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppDesignSystem.spacingLg,
          AppDesignSystem.spacingMd,
          AppDesignSystem.spacingLg,
          AppDesignSystem.spacingLg,
        ),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDesignSystem.spacingSm),
            child: Material(
              color: Colors.grey.shade100,
              borderRadius: AppDesignSystem.borderRadiusXl,
              child: InkWell(
                onTap: _goToTours,
                borderRadius: AppDesignSystem.borderRadiusXl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spacingLg,
                    vertical: AppDesignSystem.spacingSm,
                  ),
                  child: Center(
                    child: Text(
                      tags[index],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHot() {
    final l10n = AppLocalizations.of(context)!;
    if (_hotTours.isEmpty) return const SizedBox.shrink();
    return _buildSectionHeader(l10n.trending, l10n.viewMore, _goToTours,
      child: SizedBox(
        height: 258,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
          itemCount: _hotTours.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: AppDesignSystem.spacingLg),
            child: _TourCard(
              tour: _hotTours[index],
              imageIndex: index,
              showBookingCount: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TourDetailScreen(tour: _hotTours[index])),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionRecommend() {
    final l10n = AppLocalizations.of(context)!;
    if (_recommendCompanions.isEmpty) return const SizedBox.shrink();
    return _buildSectionHeader(l10n.recommend, l10n.viewMore, _goToCompanions,
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
          itemCount: _recommendCompanions.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: AppDesignSystem.spacingLg),
            child: _CompanionCard(
              companion: _recommendCompanions[index],
              imageIndex: index,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CompanionDetailScreen(companion: _recommendCompanions[index])),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTop() {
    final l10n = AppLocalizations.of(context)!;
    if (_topTours.isEmpty) return const SizedBox.shrink();
    return _buildSectionHeader(l10n.topRanking, l10n.viewMore, _goToTours,
      child: SizedBox(
        height: 258,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
          itemCount: _topTours.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: AppDesignSystem.spacingLg),
            child: _TourCard(
              tour: _topTours[index],
              imageIndex: index + 10,
              topRank: index + 1,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TourDetailScreen(tour: _topTours[index])),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent() {
    if (_trendingContent.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    return _buildSectionHeader('旅行攻略', l10n.viewMore, _goToContent,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
        itemCount: _trendingContent.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppDesignSystem.spacingLg),
        itemBuilder: (context, index) {
          final c = _trendingContent[index];
          return _ContentCard(
            content: c,
            imageIndex: index,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ContentDetailScreen(content: c)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionLabel, VoidCallback onAction, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDesignSystem.spacingLg,
            AppDesignSystem.spacingXl,
            AppDesignSystem.spacingLg,
            AppDesignSystem.spacingMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingMd),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
        const SizedBox(height: AppDesignSystem.spacingLg),
      ],
    );
  }
}

class _TourCard extends StatelessWidget {
  final Tour tour;
  final int imageIndex;
  final bool showBookingCount;
  final int? topRank;
  final VoidCallback onTap;

  const _TourCard({
    required this.tour,
    required this.imageIndex,
    this.showBookingCount = false,
    this.topRank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = tour.image ?? TravelImages.getTourImage(imageIndex);
    return SizedBox(
      width: 280,
      child: Material(
        elevation: AppDesignSystem.elevationCard,
        shadowColor: AppTheme.shadowColor,
        borderRadius: AppDesignSystem.borderRadiusImage,
        color: AppTheme.surfaceColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: TravelImages.buildImageBackground(
                      imageUrl: imageUrl,
                      opacity: 0,
                      cacheWidth: 560,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  if (showBookingCount && tour.reviewCount > 0)
                    Positioned(
                      top: AppDesignSystem.spacingSm,
                      right: AppDesignSystem.spacingSm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesignSystem.spacingSm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: AppDesignSystem.borderRadiusSm,
                        ),
                        child: Text(
                          '共${tour.reviewCount}人预订',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (topRank != null)
                    Positioned(
                      top: AppDesignSystem.spacingSm,
                      left: AppDesignSystem.spacingSm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesignSystem.spacingSm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.categoryRed,
                          borderRadius: AppDesignSystem.borderRadiusSm,
                        ),
                        child: Text(
                          'TOP $topRank',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spacingMd,
                  vertical: AppDesignSystem.spacingSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.localeName == 'zh'
                          ? (tour.titleZh ?? tour.title)
                          : tour.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceWidget(
                          price: tour.price,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.categoryRed,
                          ),
                        ),
                        RatingWidget(rating: tour.rating, reviewCount: tour.reviewCount, size: 12),
                      ],
                    ),
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

class _CompanionCard extends StatelessWidget {
  final Companion companion;
  final int imageIndex;
  final VoidCallback onTap;

  const _CompanionCard({
    required this.companion,
    required this.imageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Material(
        elevation: AppDesignSystem.elevationCard,
        shadowColor: AppTheme.shadowColor,
        borderRadius: AppDesignSystem.borderRadiusImage,
        clipBehavior: Clip.antiAlias,
        color: AppTheme.surfaceColor,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image only — no avatar on top
              SizedBox(
                height: 88,
                width: double.infinity,
                child: TravelImages.buildImageBackground(
                  imageUrl: TravelImages.getCompanionBackground(imageIndex),
                  opacity: 0.2,
                  cacheWidth: 280,
                  child: const SizedBox.expand(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppDesignSystem.spacingSm),
                child: Row(
                  children: [
                    ClipOval(
                      child: companion.avatar != null
                          ? CachedNetworkImage(
                              imageUrl: companion.avatar!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => _avatarFallback(36),
                              errorWidget: (_, __, ___) => _avatarFallback(36),
                            )
                          : Image.asset(
                              TravelImages.getCompanionAvatar(imageIndex),
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarFallback(36),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            companion.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          RatingWidget(rating: companion.rating, reviewCount: companion.reviewCount, size: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarFallback(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          companion.name.isNotEmpty ? companion.name[0] : '?',
          style: TextStyle(fontSize: size * 0.5, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final TravelContent content;
  final int imageIndex;
  final VoidCallback onTap;

  const _ContentCard({
    required this.content,
    required this.imageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = content.image ?? TravelImages.getContentImage(imageIndex);
    return Material(
      elevation: AppDesignSystem.elevationCard,
      shadowColor: AppTheme.shadowColor,
      borderRadius: AppDesignSystem.borderRadiusImage,
      clipBehavior: Clip.antiAlias,
      color: AppTheme.surfaceColor,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: TravelImages.buildImageBackground(
                imageUrl: imageUrl,
                opacity: 0,
                cacheWidth: 800,
                child: const SizedBox.expand(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.localeName == 'zh'
                        ? (content.titleZh ?? content.title)
                        : content.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.visibility_outlined, size: 14, color: AppTheme.textTertiary),
                      const SizedBox(width: 4),
                      Text('${content.views}', style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                      const SizedBox(width: 16),
                      Icon(Icons.favorite_border, size: 14, color: AppTheme.textTertiary),
                      const SizedBox(width: 4),
                      Text('${content.likes}', style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
