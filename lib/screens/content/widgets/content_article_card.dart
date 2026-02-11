import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/content.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/app_design_system.dart';
import '../../../utils/travel_images.dart';

/// Article list card: image-first, rounded corners 16–20, title, excerpt, author + date + stats (views, likes).
/// Compact variant for horizontal scroll; standard for vertical list.
class ContentArticleCard extends StatelessWidget {
  const ContentArticleCard({
    super.key,
    required this.content,
    required this.onTap,
    this.typeColor,
    this.getContentTypeLabel,
    this.compact = false,
    this.imageIndex,
  });

  final TravelContent content;
  final VoidCallback onTap;
  final Color? typeColor;
  final String Function(String type)? getContentTypeLabel;
  final bool compact;
  /// When set, used to pick a distinct image per list item. Otherwise derived from content.id.
  final int? imageIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final typeColor = this.typeColor ?? AppTheme.categoryPurple;
    final typeLabel = getContentTypeLabel?.call(content.type) ??
        (content.type == 'Guide'
            ? l10n.guide
            : content.type == 'Tips'
                ? l10n.tips
                : l10n.travelNotes);

    final title = l10n.localeName == 'zh'
        ? (content.titleZh ?? content.title)
        : content.title;
    final excerpt = l10n.localeName == 'zh'
        ? (content.contentZh ?? content.content)
        : content.content;
    final author = content.author != null
        ? (l10n.localeName == 'zh'
            ? (content.authorZh ?? content.author!)
            : content.author!)
        : null;

    final radius = BorderRadius.circular(AppDesignSystem.radiusMd);
    const imageHeight = 140.0;
    const imageHeightCompact = 120.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: compact
                ? _buildCompact(
                    context,
                    theme,
                    l10n,
                    typeColor,
                    typeLabel,
                    title,
                    excerpt,
                    author,
                    imageHeightCompact,
                  )
                : _buildStandard(
                    context,
                    theme,
                    l10n,
                    typeColor,
                    typeLabel,
                    title,
                    excerpt,
                    author,
                    imageHeight,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Color typeColor,
    String typeLabel,
    String title,
    String excerpt,
    String? author,
    double imageHeight,
  ) {
    const double compactImageHeight = 110;
    return SizedBox(
      width: 200,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDesignSystem.radiusMd),
            ),
            child: SizedBox(
              height: compactImageHeight,
              width: double.infinity,
              child: _buildImage(typeColor, typeLabel, compactImageHeight),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildMetaRow(context, theme, l10n, author, false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Color typeColor,
    String typeLabel,
    String title,
    String excerpt,
    String? author,
    double imageHeight,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(AppDesignSystem.radiusMd),
          ),
          child: SizedBox(
            width: 120,
            height: imageHeight,
            child: _buildImage(typeColor, typeLabel, imageHeight),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  excerpt,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                _buildMetaRow(context, theme, l10n, author, true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(Color typeColor, String typeLabel, double height) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          TravelImages.getContentImage(imageIndex ?? content.id.hashCode.abs() % 6),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: typeColor.withValues(alpha: 0.15),
            child: Icon(
              Icons.article_outlined,
              size: 32,
              color: typeColor.withValues(alpha: 0.6),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              typeLabel,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    String? author,
    bool showStats,
  ) {
    return Row(
      children: [
        if (author != null) ...[
          Icon(
            Icons.person_outline_rounded,
            size: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              author,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Icon(
          Icons.calendar_today_rounded,
          size: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat.yMMMd(Localizations.localeOf(context).toString())
              .format(content.publishDate),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (showStats) ...[
          const Spacer(),
          Icon(
            Icons.visibility_rounded,
            size: 14,
            color: AppTheme.categoryBlue,
          ),
          const SizedBox(width: 2),
          Text(
            '${content.views}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.categoryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.favorite_rounded,
            size: 14,
            color: AppTheme.categoryPink,
          ),
          const SizedBox(width: 2),
          Text(
            '${content.likes}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.categoryPink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
