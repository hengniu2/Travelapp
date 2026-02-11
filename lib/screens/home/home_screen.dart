import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../services/data_service.dart';
import '../../models/tour.dart';
import '../../models/companion.dart';
import '../../models/content.dart';
import '../../models/user.dart';
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
import '../profile/notifications_screen.dart';

/// Premium home: gradient header, floating search, category grid, Popular / Recommendation / Travel Guides.
/// No full-screen background images or blur. Clean layered layout.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService _dataService = DataService();
  List<Tour> _hotTours = [];
  List<Companion> _recommendCompanions = [];
  List<Tour> _topTours = [];
  List<TravelContent> _trendingContent = [];

  static const Color _pageBackground = Color(0xFFF6F7F9);
  static const Color _primaryGreen = Color(0xFF0FA958);
  static const double _headerHeight = 260;
  static const double _headerRadius = 12;
  static const double _searchBarRadius = 8;
  static const double _cardRadiusLg = 8;
  static const double _cardRadiusMd = 6;
  static const double _cardRadiusSm = 6;
  static const double _spacing = 16;
  static const double _spacingMd = 18;
  static const double _spacingLg = 20;
  static const double _spacingXl = 24;
  static const double _shadowOpacity = 0.1;

  @override
  void initState() {
    super.initState();
    _loadData();
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
      _trendingContent = content.take(3).toList();
    });
  }

  void _goToTours() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ToursScreen()));
  void _goToCompanions() => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanionsScreen()));
  void _goToBookings() => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingsScreen()));
  void _goToContent() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContentScreen()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async => _loadData(),
          color: _primaryGreen,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildHeaderSliver(),
              SliverToBoxAdapter(child: _buildCategoryGrid()),
              SliverToBoxAdapter(child: _buildSectionPopular()),
              SliverToBoxAdapter(child: _buildSectionRecommendation()),
              SliverToBoxAdapter(child: _buildSectionTravelGuides()),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSliver() {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<AppProvider>().currentUser;
    final topPadding = MediaQuery.of(context).padding.top;
    return SliverToBoxAdapter(
      child: SizedBox(
        height: _headerHeight + topPadding,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(_headerRadius)),
              child: Image.asset(
                TravelImages.getHomeHeader(0),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0A7D40),
                        const Color(0xFF0FA958),
                        const Color(0xFF1DB954),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(_headerRadius)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      const Color(0xFF0A7D40).withValues(alpha: 0.85),
                      const Color(0xFF0FA958).withValues(alpha: 0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(_spacing, _spacing, _spacing, _spacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 18, color: Colors.white.withValues(alpha: 0.95)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Shanghai',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Material(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(_cardRadiusSm),
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                            borderRadius: BorderRadius.circular(_cardRadiusSm),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildProfileAvatar(user),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.homeTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.homeSubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    _buildHeaderSearchBar(l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSearchBar(AppLocalizations l10n) {
    return Material(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: _shadowOpacity),
      borderRadius: BorderRadius.circular(_searchBarRadius),
      color: Colors.white,
      child: InkWell(
        onTap: _goToTours,
        borderRadius: BorderRadius.circular(_searchBarRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _spacingLg, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 22, color: AppTheme.textTertiary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.destinationKeywords,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(User? user) {
    final size = 40.0;
    if (user?.avatar != null && user!.avatar!.trim().isNotEmpty) {
      return ClipOval(
        child: Image.network(
          user.avatar!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarPlaceholder(size, user),
        ),
      );
    }
    return _avatarPlaceholder(size, user);
  }

  Widget _avatarPlaceholder(double size, User? user) {
    final initial = (user?.name != null && user!.name.trim().isNotEmpty) ? user.name[0].toUpperCase() : 'U';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final l10n = AppLocalizations.of(context)!;
    final categories = [
      (icon: Icons.local_fire_department_rounded, label: l10n.hot, color: const Color(0xFFFFE0B2), iconColor: AppTheme.categoryOrange, onTap: _goToTours),
      (icon: Icons.people_rounded, label: l10n.companions, color: const Color(0xFFB3E5FC), iconColor: AppTheme.categoryBlue, onTap: _goToCompanions),
      (icon: Icons.explore_rounded, label: l10n.tours, color: const Color(0xFFC8E6C9), iconColor: _primaryGreen, onTap: _goToTours),
      (icon: Icons.hotel_rounded, label: l10n.hotels, color: const Color(0xFFB2EBF2), iconColor: AppTheme.categoryCyan, onTap: _goToBookings),
      (icon: Icons.article_rounded, label: l10n.content, color: const Color(0xFFE1BEE7), iconColor: AppTheme.categoryPurple, onTap: _goToContent),
      (icon: Icons.thumb_up_rounded, label: l10n.recommend, color: const Color(0xFFF8BBD9), iconColor: AppTheme.categoryPink, onTap: _goToCompanions),
      (icon: Icons.place_rounded, label: l10n.destinations, color: const Color(0xFFFFF9C4), iconColor: AppTheme.categoryYellow, onTap: _goToTours),
      (icon: Icons.apps_rounded, label: l10n.all, color: const Color(0xFFE0E0E0), iconColor: AppTheme.textSecondary, onTap: _goToTours),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(_spacing, _spacingXl, _spacing, 0),
      padding: const EdgeInsets.all(_spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _shadowOpacity),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(4, (i) => Expanded(
              child: _categoryItem(
                icon: categories[i].icon,
                label: categories[i].label,
                bgColor: categories[i].color,
                iconColor: categories[i].iconColor,
                onTap: categories[i].onTap,
              ),
            )),
          ),
          const SizedBox(height: _spacingLg),
          Row(
            children: List.generate(4, (i) => Expanded(
              child: _categoryItem(
                icon: categories[i + 4].icon,
                label: categories[i + 4].label,
                bgColor: categories[i + 4].color,
                iconColor: categories[i + 4].iconColor,
                onTap: categories[i + 4].onTap,
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
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_cardRadiusMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionPopular() {
    final l10n = AppLocalizations.of(context)!;
    if (_hotTours.isEmpty) return const SizedBox.shrink();
    return _buildSection(
      title: l10n.popular,
      onSeeAll: _goToTours,
      child: SizedBox(
        height: 258,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: _spacing),
          itemCount: _hotTours.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: _spacing),
            child: _PopularTourCard(
              tour: _hotTours[index],
              imageIndex: index,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TourDetailScreen(tour: _hotTours[index]))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionRecommendation() {
    final l10n = AppLocalizations.of(context)!;
    if (_recommendCompanions.isEmpty) return const SizedBox.shrink();
    return _buildSection(
      title: l10n.recommend,
      onSeeAll: _goToCompanions,
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: _spacing),
          itemCount: _recommendCompanions.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: _spacing),
            child: _RecommendationCard(
              companion: _recommendCompanions[index],
              imageIndex: index,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CompanionDetailScreen(companion: _recommendCompanions[index]))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTravelGuides() {
    final l10n = AppLocalizations.of(context)!;
    if (_trendingContent.isEmpty) return const SizedBox.shrink();
    return _buildSection(
      title: l10n.travelGuides,
      onSeeAll: _goToContent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _spacing),
        child: Column(
          children: List.generate(
            _trendingContent.length,
            (index) {
              final c = _trendingContent[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: _spacing),
                child: _TravelGuideCard(
                  content: c,
                  imageIndex: index,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContentDetailScreen(content: c))),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onSeeAll,
    required Widget child,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(_spacing, _spacingXl, _spacing, _spacingMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.seeAll,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0FA958),
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _PopularTourCard extends StatelessWidget {
  final Tour tour;
  final int imageIndex;
  final VoidCallback onTap;

  const _PopularTourCard({required this.tour, required this.imageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imagePath = TravelImages.getTourImage(imageIndex);
    final title = l10n.localeName == 'zh' ? (tour.titleZh ?? tour.title) : tour.title;
    return SizedBox(
      width: 280,
      child: Material(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusLg),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.categoryBlue.withValues(alpha: 0.2),
                        child: const Icon(Icons.image_not_supported_outlined, size: 48),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Companion companion;
  final int imageIndex;
  final VoidCallback onTap;

  const _RecommendationCard({required this.companion, required this.imageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Material(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusLg),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDesignSystem.radiusLg)),
                child: SizedBox(
                  height: 88,
                  width: double.infinity,
                  child: Image.asset(
                    TravelImages.getCompanionBackground(imageIndex),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.categoryBlue.withValues(alpha: 0.2),
                      child: const Icon(Icons.person, size: 32),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        TravelImages.getCompanionAvatar(imageIndex),
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback(),
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

  Widget _avatarFallback() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        companion.name.isNotEmpty ? companion.name[0] : '?',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
      ),
    );
  }
}

class _TravelGuideCard extends StatelessWidget {
  final TravelContent content;
  final int imageIndex;
  final VoidCallback onTap;

  const _TravelGuideCard({required this.content, required this.imageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imagePath = TravelImages.getContentImage(imageIndex);
    final title = l10n.localeName == 'zh' ? (content.titleZh ?? content.title) : content.title;
    return Material(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusLg),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDesignSystem.radiusLg)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.categoryPurple.withValues(alpha: 0.2),
                    child: const Icon(Icons.article_outlined, size: 48),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
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
