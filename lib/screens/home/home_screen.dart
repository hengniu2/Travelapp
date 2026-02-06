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
  List<Tour> _featuredTours = [];
  List<Companion> _topCompanions = [];
  List<TravelContent> _trendingContent = [];

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
      _featuredTours = tours.where((t) => t.isTrending).take(3).toList();
      if (_featuredTours.length < 3) {
        _featuredTours = tours.take(3).toList();
      }
      _topCompanions = companions.where((c) => c.isAvailable).take(3).toList();
      _trendingContent = content.take(2).toList();
    });
  }

  Widget _buildWelcomeHeader() {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.currentUser;
    final l10n = AppLocalizations.of(context)!;

    // Full-width hero banner with immersive image (Ctrip/Xiaohongshu style)
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: TravelImages.buildImageBackground(
          imageUrl: TravelImages.getHomeHeader(0),
          opacity: 0.5, // Lighter overlay for better image visibility
          cacheWidth: 1200,
          child: Container(
            // Soft gradient overlay from top for text readability
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user?.name ?? l10n.guest,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar with glassmorphism effect
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: l10n.search,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppTheme.primaryColor,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ToursScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) {
      return '凌晨好';
    } else if (hour < 9) {
      return '早上好';
    } else if (hour < 12) {
      return '上午好';
    } else if (hour < 14) {
      return '中午好';
    } else if (hour < 18) {
      return '下午好';
    } else if (hour < 22) {
      return '晚上好';
    } else {
      return '夜深了';
    }
  }

  Widget _buildQuickActions() {
    final l10n = AppLocalizations.of(context)!;

    final actions = [
      {
        'title': l10n.companions,
        'icon': Icons.people,
        'color': AppTheme.categoryBlue,
        'gradient': [AppTheme.categoryBlue, const Color(0xFF64B5F6)],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompanionsScreen(),
              ),
            ),
      },
      {
        'title': l10n.tours,
        'icon': Icons.explore,
        'color': AppTheme.categoryOrange,
        'gradient': [AppTheme.categoryOrange, const Color(0xFFFFB74D)],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ToursScreen(),
              ),
            ),
      },
      {
        'title': l10n.bookings,
        'icon': Icons.hotel,
        'color': AppTheme.categoryGreen,
        'gradient': [AppTheme.categoryGreen, const Color(0xFF66BB6A)],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingsScreen(),
              ),
            ),
      },
      {
        'title': l10n.content,
        'icon': Icons.article,
        'color': AppTheme.categoryPurple,
        'gradient': [AppTheme.categoryPurple, AppTheme.categoryPink],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContentScreen(),
              ),
            ),
      },
    ];

    // Image-first action cards with overlays (Xiaohongshu style)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          final gradient = action['gradient'] as List<Color>;
          String imageUrl;
          if (action['title'] == l10n.companions) {
            imageUrl = TravelImages.getActionCompanions(index);
          } else if (action['title'] == l10n.tours) {
            imageUrl = TravelImages.getActionTours(index);
          } else if (action['title'] == l10n.bookings) {
            imageUrl = TravelImages.getActionBookings(index);
          } else {
            imageUrl = TravelImages.getActionContent(index);
          }

          return Expanded(
            child: GestureDetector(
              onTap: action['onTap'] as VoidCallback,
              child: Container(
                margin: EdgeInsets.only(right: index < actions.length - 1 ? 10 : 0),
                height: 100, // Larger cards for better image visibility
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), // 14-20px range
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: TravelImages.buildImageBackground(
                    imageUrl: imageUrl,
                    opacity: 0.4, // Lighter overlay to show more image
                    cacheWidth: 400,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              action['icon'] as IconData,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            action['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedTours() {
    if (_featuredTours.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ToursScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: const Text(
                  '查看更多',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Full-width image cards (Xiaohongshu feed style)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _featuredTours.length,
          itemBuilder: (context, index) {
            final tour = _featuredTours[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // 14-20px range
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailScreen(tour: tour),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large image with overlay
                      AspectRatio(
                        aspectRatio: 16 / 9, // Wide format for immersive feel
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            TravelImages.buildImageBackground(
                              imageUrl: TravelImages.getSafeImageUrl(tour.image, index, 1200, 675),
                              opacity: 0.0,
                              cacheWidth: 1200,
                              child: const SizedBox.shrink(),
                            ),
                            // Soft gradient overlay for text readability
                            Container(
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
                            // Trending badge
                            if (tour.isTrending)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.categoryRed,
                                        AppTheme.categoryOrange,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department,
                                        color: Colors.white,
                                        size: 14,
                                      ),
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
                            // Title overlay on image (bold, clear hierarchy)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                                child: Text(
                                  tour.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Compact info section below image
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: PriceWidget(
                                price: tour.price,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE53935),
                                ),
                              ),
                            ),
                            RatingWidget(
                              rating: tour.rating,
                              reviewCount: tour.reviewCount,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopCompanions() {
    if (_topCompanions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '推荐旅伴',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompanionsScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: const Text(
                  '查看更多',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Horizontal scroll with image-first cards
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _topCompanions.length,
            itemBuilder: (context, index) {
              final companion = _topCompanions[index];

              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompanionDetailScreen(companion: companion),
                        ),
                      );
                    },
                    child: TravelImages.buildImageBackground(
                      imageUrl: TravelImages.getCompanionBackground(index),
                      opacity: 0.5,
                      cacheWidth: 640,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Avatar with image
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: companion.avatar ??
                                      TravelImages.getCompanionAvatar(index),
                                  fit: BoxFit.cover,
                                  memCacheWidth: 224,
                                  memCacheHeight: 224,
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      color: AppTheme.categoryBlue,
                                      child: Center(
                                        child: Text(
                                          companion.name[0],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Name and info overlay
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  companion.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 3,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    RatingWidget(
                                      rating: companion.rating,
                                      reviewCount: companion.reviewCount,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTravelTips() {
    if (_trendingContent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '旅行攻略',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContentScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: const Text(
                  '查看更多',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Image-first content cards (Xiaohongshu style)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _trendingContent.length,
          itemBuilder: (context, index) {
            final content = _trendingContent[index];
            final typeColors = {
              'Guide': AppTheme.categoryBlue,
              'Tips': AppTheme.categoryOrange,
              'Travel Notes': AppTheme.categoryPurple,
            };
            final typeColor = typeColors[content.type] ?? AppTheme.primaryColor;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContentDetailScreen(content: content),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large image with overlay
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            TravelImages.buildImageBackground(
                              imageUrl: content.image ??
                                  TravelImages.getContentImage(index),
                              opacity: 0.0,
                              cacheWidth: 1200,
                              child: const SizedBox.shrink(),
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                  ],
                                  stops: const [0.6, 1.0],
                                ),
                              ),
                            ),
                            // Type badge
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: typeColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  content.type,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content info below image
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${content.views}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.favorite,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${content.likes}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
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
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(),
                _buildQuickActions(),
                _buildFeaturedTours(),
                _buildTopCompanions(),
                _buildTravelTips(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

