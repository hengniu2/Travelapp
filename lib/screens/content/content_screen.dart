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

/// Content hub: hero header, category pills, featured → trending → latest hierarchy,
/// pull-to-refresh, empty state. Travel magazine feel.
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
    final featured =
        filtered.isEmpty ? null : filtered.first;
    final trending = filtered.length > 1
        ? filtered.sublist(1, filtered.length > 4 ? 4 : filtered.length)
        : <TravelContent>[];
    final latest = filtered.length > 1
        ? filtered.sublist(1)
        : <TravelContent>[];

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: RefreshIndicator(
        onRefresh: _loadContent,
        color: AppTheme.primaryColor,
        child: CustomScrollView(
          slivers: [
            _buildHero(theme, l10n),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDesignSystem.spacingLg,
                  AppDesignSystem.spacingXl,
                  AppDesignSystem.spacingLg,
                  AppDesignSystem.spacingMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (featured != null) ...[
                      _sectionTitle(theme, l10n.featured),
                      const SizedBox(height: 12),
                      FeaturedContentCard(
                        content: featured,
                        onTap: () => pushSlideUp(
                          context,
                          ContentDetailScreen(content: featured),
                        ),
                        typeColor: _typeColor(featured.type),
                        getContentTypeLabel: (t) => _getContentTypeLabel(t, l10n),
                        imageIndex: 0,
                      ),
                    ],
                    const SizedBox(height: 28),
                    _sectionTitle(theme, l10n.hot),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: trending.isEmpty
                          ? _buildTrendingPlaceholder(context, theme)
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                left: 0,
                                right: AppDesignSystem.spacingLg,
                              ),
                              itemCount: trending.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final c = trending[index];
                                return SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: ContentArticleCard(
                                    content: c,
                                    compact: true,
                                    onTap: () => pushSlideUp(
                                      context,
                                      ContentDetailScreen(content: c),
                                    ),
                                    typeColor: _typeColor(c.type),
                                    getContentTypeLabel: (t) =>
                                        _getContentTypeLabel(t, l10n),
                                    imageIndex: index + 1,
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 28),
                    _sectionTitle(theme, l10n.latestArticles),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (latest.isEmpty)
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
                padding: const EdgeInsets.only(
                  left: AppDesignSystem.spacingLg,
                  right: AppDesignSystem.spacingLg,
                  bottom: AppDesignSystem.spacingXxl + 24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final c = latest[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ContentArticleCard(
                          content: c,
                          onTap: () => pushSlideUp(
                            context,
                            ContentDetailScreen(content: c),
                          ),
                          typeColor: _typeColor(c.type),
                          getContentTypeLabel: (t) =>
                              _getContentTypeLabel(t, l10n),
                          imageIndex: index + 1,
                        ),
                      );
                    },
                    childCount: latest.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(ThemeData theme, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              TravelImages.getContentImage(0),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.categoryPurple.withValues(alpha: 0.5),
                    AppTheme.categoryPurple.withValues(alpha: 0.75),
                    AppTheme.primaryColor.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDesignSystem.spacingLg,
              AppDesignSystem.spacingMd,
              AppDesignSystem.spacingLg,
              AppDesignSystem.spacingLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.contentDiscover,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.contentSubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AppDesignSystem.radiusMd),
                      child: InkWell(
                        onTap: () {
                          // TODO: open search
                        },
                        borderRadius:
                            BorderRadius.circular(AppDesignSystem.radiusMd),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
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
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTrendingPlaceholder(BuildContext context, ThemeData theme) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noContentFound,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: child,
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
