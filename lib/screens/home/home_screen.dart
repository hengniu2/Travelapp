import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.primaryGradient,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.name ?? l10n.guest,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.search,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onTap: () {
                // Navigate to search or tours screen
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
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          final gradient = action['gradient'] as List<Color>;
          return Expanded(
            child: GestureDetector(
              onTap: action['onTap'] as VoidCallback,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (action['color'] as Color).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            action['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Featured Tours',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _featuredTours.length,
            itemBuilder: (context, index) {
              final tour = _featuredTours[index];
              final gradients = [
                AppTheme.primaryGradient,
                AppTheme.sunsetGradient,
                AppTheme.oceanGradient,
              ];
              final gradient = gradients[index % gradients.length];

              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailScreen(tour: tour),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 260,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 160,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  tour.image ?? TravelImages.getTourImage(index),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: gradient,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white70,
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
                                        Colors.black.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                ),
                                if (tour.isTrending)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.categoryRed,
                                            AppTheme.categoryOrange,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.local_fire_department,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            'Trending',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tour.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: PriceWidget(
                                          price: tour.price,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE53935),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerRight,
                                        child: RatingWidget(
                                          rating: tour.rating,
                                          reviewCount: tour.reviewCount,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTopCompanions() {
    if (_topCompanions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Top Travel Companions',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _topCompanions.length,
            itemBuilder: (context, index) {
              final companion = _topCompanions[index];
              final gradients = [
                [AppTheme.categoryBlue, const Color(0xFF64B5F6)],
                [AppTheme.categoryOrange, const Color(0xFFFFB74D)],
                [AppTheme.categoryPurple, AppTheme.categoryPink],
              ];
              final gradient = gradients[index % gradients.length];

              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
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
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: gradient),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              companion.avatar ??
                                  TravelImages.getCompanionAvatar(index),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: gradient),
                                  ),
                                  child: Center(
                                    child: Text(
                                      companion.name[0],
                                      style: const TextStyle(
                                        fontSize: 20,
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                companion.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Flexible(
                                child: RatingWidget(
                                  rating: companion.rating,
                                  reviewCount: companion.reviewCount,
                                  size: 10,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Flexible(
                                child: PriceWidget(
                                  price: companion.pricePerDay,
                                  prefix: '¥',
                                  showFrom: false,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Travel Tips & Guides',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: typeColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              typeColor,
                              typeColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            content.image ??
                                TravelImages.getContentImage(index),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      typeColor,
                                      typeColor.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.article,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                content.type,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: typeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              content.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.visibility,
                                  size: 12,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    '${content.views}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.favorite,
                                  size: 12,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    '${content.likes}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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

