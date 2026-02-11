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
  });

  final TravelContent content;
  final VoidCallback onTap;
  final Color? typeColor;
  final String Function(String type)? getContentTypeLabel;
  /// When set, used to pick a distinct image. Otherwise derived from content.id.
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
}
