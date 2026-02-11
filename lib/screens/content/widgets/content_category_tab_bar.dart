import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/app_design_system.dart';

/// Horizontal scrollable category tabs (pill style) for the content hub.
/// Clear active state, smooth scroll. Use with [ContentCategoryTabBarController] for scroll-to-selection.
class ContentCategoryTabBar extends StatelessWidget {
  const ContentCategoryTabBar({
    super.key,
    required this.selectedKey,
    required this.onSelected,
    this.l10n,
  });

  final String selectedKey;
  final ValueChanged<String> onSelected;
  final AppLocalizations? l10n;

  static const List<String> _keys = ['all', 'guide', 'tips', 'travelNotes'];

  static Color _colorFor(String key) {
    switch (key) {
      case 'all':
        return AppTheme.primaryColor;
      case 'guide':
        return AppTheme.categoryBlue;
      case 'tips':
        return AppTheme.categoryOrange;
      case 'travelNotes':
        return AppTheme.categoryPurple;
      default:
        return AppTheme.primaryColor;
    }
  }

  static const Map<String, String> _fallbackLabels = {
    'all': '全部',
    'guide': '指南',
    'tips': '提示',
    'travelNotes': '旅行笔记',
  };

  String _label(String key, AppLocalizations l10n) {
    String text;
    switch (key) {
      case 'all':
        text = l10n.all;
        break;
      case 'guide':
        text = l10n.guide;
        break;
      case 'tips':
        text = l10n.tips;
        break;
      case 'travelNotes':
        text = l10n.travelNotes;
        break;
      default:
        text = l10n.all;
    }
    return text.isNotEmpty ? text : (_fallbackLabels[key] ?? key);
  }

  @override
  Widget build(BuildContext context) {
    final loc = l10n ?? AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _keys.map((key) {
          final isSelected = selectedKey == key;
          final color = _colorFor(key);
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(key),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [color, color.withValues(alpha: 0.85)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : color.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    _label(key, loc),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : color,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
