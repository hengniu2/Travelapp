import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/content.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/app_design_system.dart';
import '../../../utils/travel_images.dart';

/// Large hero card for the featured article: full-width image, title, short description, author + date.
/// Rounded corners 16–20, image-first, prominent title.
class FeaturedContentCard extends StatelessWidget {
  const FeaturedContentCard({
    super.key,
    required this.content,
    required this.onTap,
    this.typeColor,
    this.getContentTypeLabel,
    this.imageIndex,
    this.compact = false,
  });

  final TravelContent content;
  final VoidCallback onTap;
  final Color? typeColor;
  final String Function(String type)? getContentTypeLabel;
  /// When set, used to pick a distinct image. Otherwise derived from content.id.
  final int? imageIndex;
  /// Compact horizontal bar (image left, text right) for dense list.
  final bool compact;

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

    if (compact) {
      return _buildCompactBar(context, theme, l10n, typeColor, typeLabel, title, author);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesignSystem.radiusMd),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDesignSystem.radiusMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        TravelImages.getContentImage(
                          imageIndex ?? content.id.hashCode.abs() % 6,
                        ),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: typeColor.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: typeColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                                Colors.black.withValues(alpha: 0.85),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.95),
                            borderRadius:
                                BorderRadius.circular(AppDesignSystem.radiusSm),
                          ),
                          child: Text(
                            typeLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (author != null) ...[
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    author,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat.yMMMd(
                                          Localizations.localeOf(context)
                                              .toString())
                                      .format(content.publishDate),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
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
                Container(
                  padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                  color: theme.colorScheme.surface,
                  child: Text(
                    excerpt,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactBar(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Color typeColor,
    String typeLabel,
    String title,
    String? author,
  ) {
    const double barHeight = 92;
    const double imageSize = 92;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: Image.asset(
                    TravelImages.getContentImage(
                      imageIndex ?? content.id.hashCode.abs() % 6,
                    ),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: typeColor.withValues(alpha: 0.15),
                      child: Icon(Icons.article_outlined, color: typeColor.withValues(alpha: 0.6), size: 28),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            if (author != null) ...[
                              Icon(Icons.person_outline_rounded, size: 12, color: theme.colorScheme.onSurfaceVariant),
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
                            Icon(Icons.calendar_today_rounded, size: 11, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(content.publishDate),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 11,
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
      ),
    );
  }
}
