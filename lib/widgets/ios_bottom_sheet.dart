import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_design_system.dart';

/// iOS-style bottom sheet: rounded top corners, soft dim, smooth slide-up.
/// Use [showIosBottomSheet] to present; build content with [IosSheetActionGrid]
/// or [IosSheetActionList] for icon grids and action menus.
class IosBottomSheet extends StatelessWidget {
  const IosBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.showHandle = true,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppDesignSystem.borderRadiusTopSheet,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHandle) _buildHandle(),
            if (title != null || subtitle != null) _buildHeader(context),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppTheme.textTertiary.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDesignSystem.spacingXl,
        AppDesignSystem.spacingSm,
        AppDesignSystem.spacingXl,
        AppDesignSystem.spacingLg,
      ),
      child: Column(
        children: [
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// One action item for grid or list (icon + label + optional tint).
class IosSheetAction {
  const IosSheetAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
}

/// Icon grid layout for share panel / quick actions (iOS style).
class IosSheetActionGrid extends StatelessWidget {
  const IosSheetActionGrid({
    super.key,
    required this.actions,
    this.crossAxisCount = 4,
    this.iconSize = 28,
  });

  final List<IosSheetAction> actions;
  final int crossAxisCount;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDesignSystem.spacingLg,
        0,
        AppDesignSystem.spacingLg,
        AppDesignSystem.spacingXl,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppDesignSystem.spacingLg,
        crossAxisSpacing: AppDesignSystem.spacingMd,
        childAspectRatio: 0.85,
        children: actions.map((action) => _GridItem(action: action, iconSize: iconSize)).toList(),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({required this.action, required this.iconSize});

  final IosSheetAction action;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final color = action.color ?? AppTheme.primaryColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          action.onTap?.call();
        },
        borderRadius: AppDesignSystem.borderRadiusMd,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppDesignSystem.borderRadiusMd,
                ),
                child: Icon(action.icon, size: iconSize, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical list of actions (iOS action menu style).
class IosSheetActionList extends StatelessWidget {
  const IosSheetActionList({
    super.key,
    required this.actions,
    this.cancelLabel = '取消',
  });

  final List<IosSheetAction> actions;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDesignSystem.spacingLg,
        0,
        AppDesignSystem.spacingLg,
        AppDesignSystem.spacingXl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: AppDesignSystem.borderRadiusLg,
            child: Material(
              color: AppTheme.surfaceColor,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: actions.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: AppTheme.textTertiary.withValues(alpha: 0.2),
                ),
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (action.color ?? AppTheme.primaryColor).withValues(alpha: 0.12),
                        borderRadius: AppDesignSystem.borderRadiusSm,
                      ),
                      child: Icon(
                        action.icon,
                        size: 20,
                        color: action.color ?? AppTheme.primaryColor,
                      ),
                    ),
                    title: Text(
                      action.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      action.onTap?.call();
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacingMd),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spacingLg),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDesignSystem.borderRadiusLg,
                ),
                foregroundColor: AppTheme.textSecondary,
              ),
              child: Text(cancelLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Barrier color for soft dim (iOS-like).
const Color _kSheetBarrierColor = Color(0x80000000);

/// Shows an iOS-style bottom sheet with rounded top, dim overlay, slide-up animation.
Future<T?> showIosBottomSheet<T>({
  required BuildContext context,
  String? title,
  String? subtitle,
  bool showHandle = true,
  bool isScrollControlled = true,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: _kSheetBarrierColor,
    shape: RoundedRectangleBorder(
      borderRadius: AppDesignSystem.borderRadiusTopSheet,
    ),
    builder: (context) => IosBottomSheet(
      title: title,
      subtitle: subtitle,
      showHandle: showHandle,
      child: child,
    ),
  );
}

/// Shows the share panel (icon grid).
void showIosShareSheet(
  BuildContext context, {
  String? title,
  required List<IosSheetAction> actions,
}) {
  showIosBottomSheet(
    context: context,
    title: title ?? '分享',
    subtitle: null,
    child: SingleChildScrollView(
      child: IosSheetActionGrid(actions: actions, crossAxisCount: 4),
    ),
  );
}

/// Shows an action menu (list + cancel).
void showIosActionSheet(
  BuildContext context, {
  String? title,
  String cancelLabel = '取消',
  required List<IosSheetAction> actions,
}) {
  showIosBottomSheet(
    context: context,
    title: title,
    child: IosSheetActionList(actions: actions, cancelLabel: cancelLabel),
  );
}
