import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/content.dart';
import '../../widgets/image_first_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import '../../utils/route_transitions.dart';
import 'content_detail_screen.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final DataService _dataService = DataService();
  List<TravelContent> _content = [];
  String _selectedTypeKey = 'all'; // Use keys instead of localized strings

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() {
    _content = _dataService.getTravelContent();
  }

  List<TravelContent> get _filteredContent {
    if (_selectedTypeKey == 'all') return _content;
    
    // Map keys to actual type values in data
    final typeKeyMap = {
      'all': null,
      'guide': 'Guide',
      'tips': 'Tips',
      'travelNotes': 'Travel Notes',
    };
    
    final targetType = typeKeyMap[_selectedTypeKey];
    if (targetType == null) return _content;
    
    return _content.where((c) => c.type == targetType).toList();
  }
  
  String _getTypeLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'all':
        return l10n.all;
      case 'guide':
        return l10n.guide;
      case 'tips':
        return l10n.tips;
      case 'travelNotes':
        return l10n.travelNotes;
      default:
        return l10n.all;
    }
  }

  String _getContentTypeLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'Guide':
        return l10n.guide;
      case 'Tips':
        return l10n.tips;
      case 'Travel Notes':
        return l10n.travelNotes;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final filterColors = {
      'all': AppTheme.primaryColor,
      'guide': AppTheme.categoryBlue,
      'tips': AppTheme.categoryOrange,
      'travelNotes': AppTheme.categoryPurple,
    };
    
    return Scaffold(
      body: TravelImages.buildImageBackground(
        imageUrl: TravelImages.getContentImage(10),
        opacity: 0.08,
        cacheWidth: 1200,
        child: Container(
          color: AppTheme.backgroundColor,
          child: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['all', 'guide', 'tips', 'travelNotes']
                  .map((key) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: _selectedTypeKey == key
                                ? LinearGradient(
                                    colors: [
                                      filterColors[key]!,
                                      filterColors[key]!.withOpacity(0.8),
                                    ],
                                  )
                                : null,
                            color: _selectedTypeKey == key
                                ? null
                                : Colors.white,
                            borderRadius: AppDesignSystem.borderRadiusImage,
                            border: Border.all(
                              color: _selectedTypeKey == key
                                  ? Colors.transparent
                                  : filterColors[key]!.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: _selectedTypeKey == key
                                ? [
                                    BoxShadow(
                                      color: filterColors[key]!.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                              setState(() => _selectedTypeKey = key);
                              },
                              borderRadius: AppDesignSystem.borderRadiusImage,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  _getTypeLabel(key, l10n),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedTypeKey == key
                                        ? Colors.white
                                        : filterColors[key]!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: _filteredContent.isEmpty
                ? EmptyState(
                    icon: Icons.article_outlined,
                    headline: l10n.noContentFound,
                    subtitle: l10n.contentEmptySubtitle,
                    iconColor: AppTheme.categoryPurple,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                    itemCount: _filteredContent.length,
                    itemBuilder: (context, index) {
                      final content = _filteredContent[index];
                      final typeColors = {
                        'Guide': AppTheme.categoryBlue,
                        'Tips': AppTheme.categoryOrange,
                        'Travel Notes': AppTheme.categoryPurple,
                      };
                      final typeColor = typeColors[content.type] ?? AppTheme.primaryColor;
                      final gradients = [
                        AppTheme.primaryGradient,
                        AppTheme.sunsetGradient,
                        AppTheme.oceanGradient,
                        AppTheme.purpleGradient,
                      ];
                      final gradient = gradients[index % gradients.length];
                      
                      return ImageFirstCard(
                        onTap: () {
                          pushSlideUp(
                            context,
                            ContentDetailScreen(content: content),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(AppDesignSystem.radiusImage)),
                                child: Stack(
                                    children: [
                                Container(
                                        height: 220,
                                  width: double.infinity,
                                  child: TravelImages.buildImageBackground(
                                    imageUrl: TravelImages.getSafeImageUrl(
                                      content.image, 
                                      index, 
                                      800, 
                                      600
                                    ),
                                    opacity: 0.0,
                                    cacheWidth: 800,
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                                // Gradient overlay
                                Positioned.fill(
                                        child: Container(
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
                                      ),
                                      // Type badge
                                      Positioned(
                                        top: AppDesignSystem.spacingMd,
                                        left: AppDesignSystem.spacingMd,
                                        child: CardBadge(
                                          label: _getContentTypeLabel(content.type, l10n),
                                          color: typeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(AppDesignSystem.spacingXl),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.localeName == 'zh'
                                          ? (content.titleZh ?? content.title)
                                          : content.title,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.localeName == 'zh'
                                          ? (content.contentZh ?? content.content)
                                          : content.content,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        if (content.author != null) ...[
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: typeColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.person,
                                                size: 14, color: typeColor),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            l10n.localeName == 'zh'
                                                ? (content.authorZh ?? content.author!)
                                                : content.author!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                        ],
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: typeColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(Icons.calendar_today,
                                              size: 14, color: typeColor),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          DateFormat.yMMMd(Localizations.localeOf(context).toString())
                                              .format(content.publishDate),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.categoryBlue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.visibility,
                                                  size: 14, color: AppTheme.categoryBlue),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${content.views}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppTheme.categoryBlue,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.categoryPink.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                        Icon(Icons.favorite,
                                                  size: 14, color: AppTheme.categoryPink),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${content.likes}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppTheme.categoryPink,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      );
                    },
                  ),
          ),
        ],
          ),
        ),
      ),
    );
  }
}



