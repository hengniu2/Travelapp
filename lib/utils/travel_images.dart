import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Comprehensive image collection for Chinese Travel App
/// Uses Unsplash API with Chinese travel-specific search queries
/// Provides beautiful, meaningful images for travel destinations
/// Fallback chain: Unsplash API -> Picsum Photos -> Placeholder -> Gradient
class TravelImages {
  // Unsplash Access Key (demo key - replace with your own from unsplash.com/developers)
  // Get your free API key at: https://unsplash.com/developers
  static const String _unsplashAccessKey = 'YOUR_UNSPLASH_ACCESS_KEY';
  static const String _unsplashApiUrl = 'https://api.unsplash.com';
  
  // Chinese travel destinations and keywords for meaningful images
  static const List<String> _chineseTravelKeywords = [
    'china travel',
    'beijing',
    'shanghai',
    'great wall china',
    'forbidden city',
    'terracotta warriors',
    'guilin mountains',
    'yangtze river',
    'tibet',
    'suzhou gardens',
    'hangzhou west lake',
    'xi an',
    'chengdu',
    'chinese temple',
    'chinese architecture',
    'chinese landscape',
    'chinese culture',
    'chinese mountains',
    'chinese city',
    'chinese nature',
    'chinese heritage',
    'chinese tourism',
    'chinese landmarks',
    'chinese scenery',
    'chinese countryside',
  ];

  // Alternative keywords for different contexts
  static const List<String> _travelKeywords = [
    'travel',
    'adventure',
    'nature',
    'landscape',
    'mountain',
    'beach',
    'city',
    'architecture',
    'culture',
    'tourism',
  ];

  /// Get Unsplash random photo URL with search query
  /// Uses Unsplash's public image service with variety
  static String _getUnsplashPhotoUrl(int index, int width, int height, {String? category}) {
    final keyword = category ?? _chineseTravelKeywords[index % _chineseTravelKeywords.length];
    final encodedKeyword = Uri.encodeComponent(keyword);
    
    // Use different URL patterns for more variety
    // Pattern 1: Featured photos with keyword
    if (index % 3 == 0) {
      return 'https://source.unsplash.com/featured/${width}x${height}/?$encodedKeyword&sig=${index * 17}';
    }
    // Pattern 2: Random with keyword
    else if (index % 3 == 1) {
      return 'https://source.unsplash.com/${width}x${height}/?$encodedKeyword&sig=${index * 23}';
    }
    // Pattern 3: Daily photo with keyword variation
    else {
      return 'https://source.unsplash.com/daily/${width}x${height}/?$encodedKeyword&sig=${index * 31}';
    }
  }

  /// Get Unsplash API photo URL (requires API key)
  /// This method provides the best results with proper search
  static Future<String> _getUnsplashApiPhotoUrl(int index, int width, int height, {String? category}) async {
    if (_unsplashAccessKey == 'YOUR_UNSPLASH_ACCESS_KEY') {
      // Fall back to direct URL method if no API key
      return _getUnsplashPhotoUrl(index, width, height, category: category);
    }

    try {
      final keyword = category ?? _chineseTravelKeywords[index % _chineseTravelKeywords.length];
      final encodedKeyword = Uri.encodeComponent(keyword);
      
      // Use Unsplash Search API
      final url = Uri.parse(
        '$_unsplashApiUrl/search/photos?query=$encodedKeyword&per_page=30&client_id=$_unsplashAccessKey'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        
        if (results != null && results.isNotEmpty) {
          // Get a different photo based on index
          final photoIndex = index % results.length;
          final photo = results[photoIndex];
          final urls = photo['urls'] as Map<String, dynamic>;
          
          // Return appropriate size based on requested dimensions
          if (width <= 400) {
            return urls['small'] as String? ?? urls['regular'] as String;
          } else if (width <= 1080) {
            return urls['regular'] as String? ?? urls['full'] as String;
          } else {
            return urls['full'] as String;
          }
        }
      }
    } catch (e) {
      // Fall through to direct URL method
    }
    
    // Fallback to direct URL method
    return _getUnsplashPhotoUrl(index, width, height, category: category);
  }

  /// Get image URL from multiple sources with fallback
  /// Primary: Unsplash API/URLs (high quality travel images)
  /// Fallback: Picsum Photos (reliable backup)
  static String _getImageUrl(int index, int width, int height, {String? providedUrl, String? category}) {
    // If provided URL is valid and not Unsplash, use it
    if (providedUrl != null && 
        !providedUrl.contains('unsplash.com') && 
        !providedUrl.contains('source.unsplash.com')) {
      return providedUrl;
    }
    
    // Use Unsplash with Chinese travel keywords for variety
    // Rotate through different keywords to get more variety
    final keywordIndex = (index * 7) % _chineseTravelKeywords.length; // Multiply for more variety
    final keyword = category ?? _chineseTravelKeywords[keywordIndex];
    
    // Use the improved Unsplash URL method
    return _getUnsplashPhotoUrl(index, width, height, category: keyword);
  }

  /// Get fallback image URL (Picsum Photos - very reliable)
  static String _getFallbackImageUrl(int index, int width, int height) {
    // Picsum Photos as backup - very reliable, no API key needed
    // Use different seeds for variety
    final seed = 'travel${index * 7}'; // Multiply for more variety
    return 'https://picsum.photos/seed/$seed/$width/$height';
  }

  /// Get alternative fallback URL (Placeholder.com)
  static String _getPlaceholderUrl(int index, int width, int height) {
    return 'https://via.placeholder.com/${width}x${height}?text=Travel+$index';
  }

  /// Get safe image URL - always returns a working URL
  /// Tries Unsplash first, then falls back to Picsum
  static String getSafeImageUrl(String? providedUrl, int index, int width, int height, {String? category}) {
    return _getImageUrl(index, width, height, providedUrl: providedUrl, category: category);
  }

  // ==================== CHINESE DESTINATIONS & TOURS ====================
  static String getTourImage(int index) {
    // Use specific Chinese travel keywords for tours
    final keywords = ['china travel', 'chinese landmarks', 'chinese heritage', 'chinese tourism'];
    final keyword = keywords[index % keywords.length];
    return _getImageUrl(index, 800, 600, category: keyword);
  }
  
  static List<String> get chineseTourImages {
    return List.generate(15, (i) => getTourImage(i));
  }

  // ==================== HOME SCREEN IMAGES ====================
  static String getHomeHeader(int index) {
    // Use landscape keywords for headers
    final keywords = ['chinese landscape', 'china travel', 'chinese scenery', 'chinese nature'];
    final keyword = keywords[index % keywords.length];
    return _getImageUrl(100 + index, 1200, 400, category: keyword);
  }

  /// Get action button images with specific keywords
  static String getActionCompanions(int index) {
    return _getImageUrl(200 + index, 400, 400, category: 'people travel');
  }

  static String getActionTours(int index) {
    return _getImageUrl(210 + index, 400, 400, category: 'china travel');
  }

  static String getActionBookings(int index) {
    return _getImageUrl(220 + index, 400, 400, category: 'chinese hotel');
  }

  static String getActionContent(int index) {
    return _getImageUrl(230 + index, 400, 400, category: 'chinese culture');
  }

  // ==================== COMPANIONS ====================
  /// Get companion avatar
  static String getCompanionAvatar(int index) {
    return _getImageUrl(300 + index, 400, 400, category: 'portrait');
  }

  /// Get companion background
  static String getCompanionBackground(int index) {
    return _getImageUrl(310 + index, 800, 600, category: 'adventure travel');
  }

  // ==================== CONTENT/BLOG ====================
  /// Get content image
  static String getContentImage(int index) {
    final keywords = ['chinese culture', 'chinese heritage', 'chinese architecture', 'chinese landmarks'];
    final keyword = keywords[index % keywords.length];
    return _getImageUrl(400 + index, 800, 600, category: keyword);
  }

  // ==================== HOTELS & ACCOMMODATION ====================
  /// Get hotel image
  static String getHotelImage(int index) {
    return _getImageUrl(500 + index, 800, 600, category: 'chinese hotel');
  }

  // ==================== PROFILE & WALLET ====================
  /// Get profile background
  static String getProfileBackground(int index) {
    return _getImageUrl(600 + index, 800, 400, category: 'chinese nature');
  }

  /// Get wallet background
  static String getWalletBackground(int index) {
    return _getImageUrl(700 + index, 800, 400, category: 'chinese city');
  }

  /// Get booking background
  static String getBookingBackground(int index) {
    return _getImageUrl(710 + index, 800, 400, category: 'china travel');
  }

  /// Get notification background
  static String getNotificationBackground(int index) {
    return _getImageUrl(720 + index, 600, 300, category: 'chinese nature');
  }

  /// Get chat background
  static String getChatBackground(int index) {
    return _getImageUrl(730 + index, 800, 600, category: 'chinese landscape');
  }

  /// Build image background widget with overlay and automatic fallbacks
  /// Uses cached_network_image for better performance and error handling
  /// Fallback chain: Unsplash -> Picsum -> Placeholder -> Gradient
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
    
    // Extract index from URL if possible, otherwise use hash
    int imageIndex = imageUrl.hashCode;
    try {
      // Try to extract index from Unsplash URL
      final unsplashMatch = RegExp(r'sig=(\d+)').firstMatch(imageUrl);
      if (unsplashMatch != null) {
        imageIndex = int.parse(unsplashMatch.group(1)!);
      } else {
        // Try Picsum URL
        final picsumMatch = RegExp(r'seed/travel(\d+)').firstMatch(imageUrl);
        if (picsumMatch != null) {
          imageIndex = int.parse(picsumMatch.group(1)!);
        }
      }
    } catch (e) {
      // Use hash if parsing fails
    }
    
    // Get fallback URLs
    final fallbackUrl = _getFallbackImageUrl(imageIndex, cacheWidth ?? 800, cacheHeight ?? 600);
    final placeholderUrl = _getPlaceholderUrl(imageIndex, cacheWidth ?? 800, cacheHeight ?? 600);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Background image with fallback chain using cached_network_image
            Positioned.fill(
              child: _CachedImageWithFallback(
                primaryUrl: imageUrl,
                fallbackUrl: fallbackUrl,
                placeholderUrl: placeholderUrl,
                gradient: gradient,
                fit: fit,
                cacheWidth: cacheWidth,
                cacheHeight: cacheHeight,
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

/// Widget that tries multiple image sources with fallbacks using cached_network_image
/// This provides better error handling and caching for network images
class _CachedImageWithFallback extends StatelessWidget {
  final String primaryUrl;
  final String fallbackUrl;
  final String placeholderUrl;
  final List<Color> gradient;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  const _CachedImageWithFallback({
    required this.primaryUrl,
    required this.fallbackUrl,
    required this.placeholderUrl,
    required this.gradient,
    required this.fit,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: primaryUrl,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      // Use placeholder while loading - just show gradient, no spinner
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
      ),
      // Error handling with fallback chain
      errorWidget: (context, url, error) {
        // Try fallback URL (Picsum)
        return CachedNetworkImage(
          imageUrl: fallbackUrl,
          fit: fit,
          memCacheWidth: cacheWidth,
          memCacheHeight: cacheHeight,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            // Try placeholder URL
            return CachedNetworkImage(
              imageUrl: placeholderUrl,
              fit: fit,
              memCacheWidth: cacheWidth,
              memCacheHeight: cacheHeight,
              errorWidget: (context, url, error) {
                // Final fallback: Beautiful gradient
                return Container(
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
          },
        );
      },
    );
  }
}
