import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/content.dart';
import '../../widgets/detail_bottom_bar.dart';
import '../../widgets/ios_bottom_sheet.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

class ContentDetailScreen extends StatelessWidget {
  final TravelContent content;

  const ContentDetailScreen({super.key, required this.content});

  static String _contentTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
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
    final appProvider = Provider.of<AppProvider>(context);
    final typeColors = {
      'Guide': AppTheme.categoryBlue,
      'Tips': AppTheme.categoryOrange,
      'Travel Notes': AppTheme.categoryPurple,
    };
    final typeColor = typeColors[content.type] ?? AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ─── Large header image ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 380,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          TravelImages.buildImageBackground(
                            imageUrl: TravelImages.getSafeImageUrl(
                              content.image,
                              content.hashCode,
                              800,
                              600,
                            ),
                            opacity: 0.0,
                            cacheWidth: 800,
                            child: const SizedBox.shrink(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 8,
                      child: Material(
                        color: Colors.black45,
                        borderRadius: AppDesignSystem.borderRadiusImage,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: AppDesignSystem.borderRadiusImage,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.95),
                          borderRadius: AppDesignSystem.borderRadiusSm,
                          boxShadow: [
                            BoxShadow(
                              color: typeColor.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _contentTypeLabel(context, content.type),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppDesignSystem.spacingLg, 0, AppDesignSystem.spacingLg, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ─── Above the fold: title, meta ───────────────────────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.localeName == 'zh'
                                ? (content.titleZh ?? content.title)
                                : content.title,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: AppDesignSystem.spacingLg),
                          Row(
                            children: [
                              if (content.author != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: typeColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.person, size: 20, color: typeColor),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.localeName == 'zh'
                                            ? (content.authorZh ?? content.author!)
                                            : content.author!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(content.publishDate),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                Icon(Icons.calendar_today, size: 20, color: typeColor),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(content.publishDate),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                              const SizedBox(width: 12),
                              _metaChip(
                                Icons.visibility,
                                '${content.views}',
                                AppTheme.categoryBlue,
                              ),
                              const SizedBox(width: 8),
                              _metaChip(
                                Icons.favorite,
                                '${content.likes}',
                                AppTheme.categoryPink,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (content.tags != null && content.tags!.isNotEmpty) ...[
                      const SizedBox(height: AppDesignSystem.spacingLg),
                      _sectionCard(
                        title: l10n.tagsLabel,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: content.tags!
                              .map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: typeColor.withValues(alpha: 0.12),
                                      borderRadius: AppDesignSystem.borderRadiusSm,
                                      border: Border.all(
                                        color: typeColor.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: typeColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDesignSystem.spacingLg),
                    _sectionCard(
                      title: l10n.bodyLabel,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.06),
                          borderRadius: AppDesignSystem.borderRadiusSm,
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          l10n.localeName == 'zh'
                              ? (content.contentZh ?? content.content)
                              : content.content,
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.8,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacingXxl),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DetailBottomBar(
              showFavorite: true,
              isFavorite: appProvider.isFavorite(content.id),
              onFavoriteTap: () => appProvider.toggleFavorite(content.id),
              price: null,
              primaryLabel: AppLocalizations.of(context)!.share,
              onPrimaryTap: () {
                showIosShareSheet(
                  context,
                  title: AppLocalizations.of(context)!.share,
                  actions: [
                    IosSheetAction(
                      icon: Icons.chat,
                      label: AppLocalizations.of(context)!.wechat,
                      onTap: () => _onShare(context, AppLocalizations.of(context)!.wechat),
                      color: const Color(0xFF07C160),
                    ),
                    IosSheetAction(
                      icon: Icons.campaign,
                      label: AppLocalizations.of(context)!.weibo,
                      onTap: () => _onShare(context, AppLocalizations.of(context)!.weibo),
                      color: const Color(0xFFE6162D),
                    ),
                    IosSheetAction(
                      icon: Icons.link,
                      label: AppLocalizations.of(context)!.copyLink,
                      onTap: () => _onShare(context, AppLocalizations.of(context)!.copyLink),
                      color: AppTheme.categoryBlue,
                    ),
                    IosSheetAction(
                      icon: Icons.more_horiz,
                      label: AppLocalizations.of(context)!.more,
                      onTap: () => _onShare(context, AppLocalizations.of(context)!.more),
                      color: AppTheme.textSecondary,
                    ),
                  ],
                );
              },
              primaryEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _onShare(BuildContext context, String channel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.sharedTo(channel)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _sectionCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesignSystem.spacingXl),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppDesignSystem.borderRadiusXl,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesignSystem.spacingLg),
          ],
          child,
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppDesignSystem.borderRadiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
