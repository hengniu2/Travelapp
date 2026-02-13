import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/content.dart';
import '../../widgets/empty_state.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import '../../utils/route_transitions.dart';
import 'content_detail_screen.dart';
import 'widgets/content_category_tab_bar.dart';
import 'widgets/featured_content_card.dart';
import 'widgets/content_article_card.dart';

/// Content hub: compact rich header, category pills, dense list of articles.
/// Magazine-style with many items per screen and rich detail in articles.
class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final DataService _dataService = DataService();
  List<TravelContent> _content = [];
  String _selectedTypeKey = 'all';

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _content = _dataService.getTravelContent();
    });
  }

  List<TravelContent> get _filteredContent {
    if (_selectedTypeKey == 'all') return _content;
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

  Color _typeColor(String type) {
    switch (type) {
      case 'Guide':
        return AppTheme.categoryBlue;
      case 'Tips':
        return AppTheme.categoryOrange;
      case 'Travel Notes':
        return AppTheme.categoryPurple;
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final filtered = _filteredContent;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: RefreshIndicator(
        onRefresh: _loadContent,
        color: AppTheme.primaryColor,
        child: CustomScrollView(
          slivers: [
            _buildCompactHeader(theme, l10n),
            SliverPersistentHeader(
              pinned: true,
              delegate: _CategorySliverDelegate(
                child: ContentCategoryTabBar(
                  selectedKey: _selectedTypeKey,
                  onSelected: (key) => setState(() => _selectedTypeKey = key),
                  l10n: l10n,
                ),
              ),
            ),
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: EmptyState(
                    icon: Icons.article_outlined,
                    headline: l10n.noContentFound,
                    subtitle: l10n.contentEmptySubtitle,
                    iconColor: AppTheme.categoryPurple,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        final c = filtered[0];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FeaturedContentCard(
                            content: c,
                            compact: true,
                            onTap: () => pushSlideUp(
                              context,
                              ContentDetailScreen(content: c),
                            ),
                            typeColor: _typeColor(c.type),
                            getContentTypeLabel: (t) => _getContentTypeLabel(t, l10n),
                            imageIndex: 0,
                          ),
                        );
                      }
                      final item = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ContentArticleCard(
                          content: item,
                          dense: true,
                          onTap: () => pushSlideUp(
                            context,
                            ContentDetailScreen(content: item),
                          ),
                          typeColor: _typeColor(item.type),
                          getContentTypeLabel: (t) => _getContentTypeLabel(t, l10n),
                          imageIndex: index,
                        ),
                      );
                    },
                    childCount: filtered.isEmpty ? 0 : filtered.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Compact rich header: smaller hero, search bar, trending chips.
  Widget _buildCompactHeader(ThemeData theme, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.categoryPurple.withValues(alpha: 0.85),
              AppTheme.primaryColor.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.contentDiscover,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.contentSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.95), size: 22),
                          const SizedBox(width: 10),
                          Text(
                            l10n.search,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Row(
                  children: [
                    _headerChip(l10n.featured, Icons.star_rounded),
                    const SizedBox(width: 8),
                    _headerChip(l10n.hot, Icons.local_fire_department),
                    const SizedBox(width: 8),
                    _headerChip(l10n.latestArticles, Icons.article_outlined),
                    const SizedBox(width: 8),
                    _headerChip(l10n.guide, Icons.explore),
                    const SizedBox(width: 8),
                    _headerChip(l10n.tips, Icons.lightbulb_outline),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySliverDelegate extends SliverPersistentHeaderDelegate {
  _CategorySliverDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
