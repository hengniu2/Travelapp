import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Comprehensive image collection for Chinese Travel App
/// Uses local meaningful images from assets/images folder
class TravelImages {
  // ==================== HOME SCREEN IMAGES ====================
  static String getHomeHeader(int index) {
    final images = [
      'assets/images/home/header/home_header_bg_1.jpg',
      'assets/images/home/header/home_header_bg_2.jpg',
      'assets/images/home/header/home_header_bg_3.jpg',
  ];
    return images[index % images.length];
  }

  /// Get action button images
  static String getActionCompanions(int index) {
    final images = [
      'assets/images/home/actions/action_companions_bg_1.jpg',
      'assets/images/home/actions/action_companions_bg_2.jpg',
      'assets/images/home/actions/action_companions_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  static String getActionTours(int index) {
    final images = [
      'assets/images/home/actions/action_tours_bg_1.jpg',
      'assets/images/home/actions/action_tours_bg_2.jpg',
      'assets/images/home/actions/action_tours_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  static String getActionBookings(int index) {
    final images = [
      'assets/images/home/actions/action_bookings_bg_1.jpg',
      'assets/images/home/actions/action_bookings_bg_2.jpg',
      'assets/images/home/actions/action_bookings_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  static String getActionContent(int index) {
    final images = [
      'assets/images/home/actions/action_content_bg_1.jpg',
      'assets/images/home/actions/action_content_bg_2.jpg',
      'assets/images/home/actions/action_content_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  // ==================== TOURS ====================
  static String getTourImage(int index) {
    final images = [
      'assets/images/tours/cards/tour_list_item_1.jpg',
      'assets/images/tours/cards/tour_list_item_2.jpg',
      'assets/images/tours/cards/tour_list_item_3.jpg',
      'assets/images/tours/cards/tour_list_item_4.jpg',
      'assets/images/tours/cards/tour_list_item_5.jpg',
      'assets/images/tours/cards/tour_list_item_6.jpg',
      'assets/images/home/tours/tour_card_bg_1.jpg',
      'assets/images/home/tours/tour_card_bg_2.jpg',
      'assets/images/tours/detail/tour_detail_hero_1.jpg',
      'assets/images/tours/detail/tour_detail_hero_2.jpg',
      'assets/images/tours/detail/tour_detail_hero_3.jpg',
    ];
    return images[index % images.length];
  }
  
  static List<String> get chineseTourImages {
    return List.generate(15, (i) => getTourImage(i));
  }

  /// Light-style header image for Tours page (use with low opacity for soft background).
  static String getToursPageHeader(int index) {
    final images = [
      'assets/images/tours/headers/tours_header_bg_1.jpg',
      'assets/images/tours/headers/tours_header_bg_2.jpg',
      'assets/images/tours/headers/tours_header_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  // ==================== COMPANIONS ====================
  /// Get companion avatar
  static String getCompanionAvatar(int index) {
    final images = [
      'assets/images/companions/avatars/companion_avatar_1.jpg',
      'assets/images/companions/avatars/companion_avatar_2.jpg',
      'assets/images/companions/avatars/companion_avatar_3.jpg',
    ];
    return images[index % images.length];
  }

  /// Get companion background (for list cards and detail content).
  /// Rotates through card + detail + profile images.
  static String getCompanionBackground(int index) {
    final images = [
      'assets/images/home/companions/companion_card_bg_1.jpg',
      'assets/images/home/companions/companion_card_bg_2.jpg',
      'assets/images/companions/detail/companion_detail_header_1.jpg',
      'assets/images/companions/detail/companion_detail_header_2.jpg',
      'assets/images/companions/detail/companion_detail_header_3.jpg',
      'assets/images/companions/detail/companion_detail_header_4.jpg',
      'assets/images/companions/profiles/companion_profile_bg_1.jpg',
      'assets/images/companions/profiles/companion_profile_bg_2.jpg',
      'assets/images/companions/profiles/companion_profile_bg_3.jpg',
      'assets/images/companions/profiles/companion_profile_bg_4.jpg',
    ];
    return images[index % images.length];
  }

  /// Get companions page header image only (different pool from cards so header ≠ card images).
  /// Rotates by [index] so you can vary it (e.g. by day or section).
  static String getCompanionPageHeader(int index) {
    final images = [
      'assets/images/home/actions/action_companions_bg_1.jpg',
      'assets/images/home/actions/action_companions_bg_2.jpg',
      'assets/images/home/actions/action_companions_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  // ==================== CONTENT/BLOG ====================
  /// Get content image
  static String getContentImage(int index) {
    final images = [
      'assets/images/home/content/content_card_bg_1.jpg',
      'assets/images/tours/cards/tour_list_item_1.jpg',
      'assets/images/tours/cards/tour_list_item_2.jpg',
      'assets/images/tours/cards/tour_list_item_3.jpg',
      'assets/images/tours/cards/tour_list_item_4.jpg',
      'assets/images/tours/cards/tour_list_item_5.jpg',
    ];
    return images[index % images.length];
  }

  // ==================== HOTELS & ACCOMMODATION ====================
  /// Get hotel image
  static String getHotelImage(int index) {
    final images = [
      'assets/images/bookings/hotels/booking_hotels_bg_1.jpg',
      'assets/images/bookings/hotels/booking_hotels_bg_2.jpg',
      'assets/images/bookings/hotels/booking_hotels_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  // ==================== PROFILE & WALLET ====================
  /// Get profile background
  static String getProfileBackground(int index) {
    // Use tour images as profile backgrounds
    final images = [
      'assets/images/tours/headers/tours_header_bg_1.jpg',
      'assets/images/tours/headers/tours_header_bg_2.jpg',
      'assets/images/tours/headers/tours_header_bg_3.jpg',
      'assets/images/home/header/home_header_bg_1.jpg',
      'assets/images/home/header/home_header_bg_2.jpg',
      'assets/images/home/header/home_header_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  /// Get wallet background
  static String getWalletBackground(int index) {
    final images = [
      'assets/images/tours/headers/tours_header_bg_1.jpg',
      'assets/images/tours/headers/tours_header_bg_2.jpg',
      'assets/images/tours/headers/tours_header_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  /// Get booking background
  static String getBookingBackground(int index) {
    final images = [
      'assets/images/bookings/hotels/booking_hotels_bg_1.jpg',
      'assets/images/bookings/hotels/booking_hotels_bg_2.jpg',
      'assets/images/bookings/hotels/booking_hotels_bg_3.jpg',
      'assets/images/tours/headers/tours_header_bg_1.jpg',
      'assets/images/tours/headers/tours_header_bg_2.jpg',
    ];
    return images[index % images.length];
  }

  /// Get notification background
  static String getNotificationBackground(int index) {
    final images = [
      'assets/images/home/header/home_header_bg_1.jpg',
      'assets/images/home/header/home_header_bg_2.jpg',
      'assets/images/home/header/home_header_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  /// Get chat background
  static String getChatBackground(int index) {
    final images = [
      'assets/images/companions/profiles/companion_profile_bg_1.jpg',
      'assets/images/companions/profiles/companion_profile_bg_2.jpg',
      'assets/images/companions/profiles/companion_profile_bg_3.jpg',
    ];
    return images[index % images.length];
  }

  /// Get safe image URL - returns local asset path or provided URL
  static String getSafeImageUrl(String? providedUrl, int index, int width, int height, {String? category}) {
    // If provided URL is valid and not a local asset, use it
    if (providedUrl != null && 
        !providedUrl.startsWith('assets/images/') &&
        !providedUrl.startsWith('assets/')) {
      return providedUrl;
    }
    
    // Otherwise use tour image as default
    return getTourImage(index);
  }

  /// Build image background widget with overlay
  /// Handles both local assets and network images
  static Widget buildImageBackground({
    required String imageUrl,
    required Widget child,
    double opacity = 0.6,
    Color overlayColor = Colors.black,
    BoxFit fit = BoxFit.cover,
    int? cacheWidth,
    int? cacheHeight,
    List<Color>? fallbackGradient,
  }) {
    // Use provided fallback gradient or generate one from imageUrl hash
    final gradient = fallbackGradient ?? getGradientForIndex(imageUrl.hashCode);
    
    // Check if it's a local asset
    final isLocalAsset = imageUrl.startsWith('assets/images/') || imageUrl.startsWith('assets/');
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Background image
            Positioned.fill(
              child: isLocalAsset
                  ? _LocalImageWidget(
                      assetPath: imageUrl,
                      fit: fit,
                gradient: gradient,
                    )
                  : _CachedNetworkImageWidget(
                      imageUrl: imageUrl,
                fit: fit,
                cacheWidth: cacheWidth,
                cacheHeight: cacheHeight,
                      gradient: gradient,
              ),
            ),
            // Dark overlay for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: overlayColor.withOpacity(opacity),
                ),
              ),
            ),
            // Child content
            child,
          ],
        );
      },
    );
  }

  /// Build rounded image background
  static Widget buildRoundedImageBackground({
    required String imageUrl,
    required Widget child,
    double opacity = 0.6,
    Color overlayColor = Colors.black,
    double borderRadius = 20,
    BoxFit fit = BoxFit.cover,
    int? cacheWidth,
    int? cacheHeight,
    List<Color>? fallbackGradient,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: buildImageBackground(
        imageUrl: imageUrl,
        child: child,
        opacity: opacity,
        overlayColor: overlayColor,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        fallbackGradient: fallbackGradient,
      ),
    );
  }

  /// Get gradient colors for fallback
  static List<Color> getGradientForIndex(int index) {
    final gradients = [
      [const Color(0xFF00C853), const Color(0xFF00A844)], // Green
      [const Color(0xFFFF6B35), const Color(0xFFF7931E)], // Orange
      [const Color(0xFF2979FF), const Color(0xFF00E5FF)], // Blue
      [const Color(0xFFAA00FF), const Color(0xFFFF4081)], // Purple
      [const Color(0xFFFF1744), const Color(0xFFFF6B6B)], // Red
      [const Color(0xFFFFD600), const Color(0xFFFFB74D)], // Yellow
    ];
    return gradients[index.abs() % gradients.length];
  }
}

/// Widget for local asset images
class _LocalImageWidget extends StatefulWidget {
  final String assetPath;
  final BoxFit fit;
  final List<Color> gradient;

  const _LocalImageWidget({
    required this.assetPath,
    required this.fit,
    required this.gradient,
  });

  @override
  State<_LocalImageWidget> createState() => _LocalImageWidgetState();
}

class _LocalImageWidgetState extends State<_LocalImageWidget> {
  bool _assetExists = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _verifyAsset();
  }

  Future<void> _verifyAsset() async {
    try {
      await rootBundle.load(widget.assetPath);
      if (mounted) {
        setState(() {
          _assetExists = true;
          _isLoading = false;
        });
        debugPrint('✅ Asset found: ${widget.assetPath}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _assetExists = false;
          _isLoading = false;
        });
        debugPrint('❌ Asset not found: ${widget.assetPath}');
        debugPrint('   Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show gradient while verifying asset
      return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.gradient,
          ),
        ),
      );
    }

    if (!_assetExists) {
      // Asset doesn't exist, show gradient fallback
      return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.gradient,
          ),
        ),
      );
    }

    // Asset exists, load it
    return Image.asset(
      widget.assetPath,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Error loading asset: ${widget.assetPath}');
        debugPrint('   Error: $error');
        
        // Fallback to gradient if image fails to load - with proper constraints
        return Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradient,
            ),
          ),
        );
      },
    );
  }
}

/// Widget for network images with fallback
class _CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;
  final List<Color> gradient;

  const _CachedNetworkImageWidget({
    required this.imageUrl,
    required this.fit,
    this.cacheWidth,
    this.cacheHeight,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      // Use placeholder while loading - show gradient with proper constraints
      placeholder: (context, url) => Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
      ),
      // Error handling with gradient fallback - with proper constraints
      errorWidget: (context, url, error) {
                return Container(
          constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                  ),
        );
      },
    );
  }
}
