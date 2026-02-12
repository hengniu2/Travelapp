import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../utils/app_design_system.dart';
import '../l10n/app_localizations.dart';
import 'price_widget.dart';

// Premium floating bar constants (Airbnb / Ctrip style)
const double _barTopRadius = 22.0;
const double _barElevation = 14.0;
const double _barPaddingH = 20.0;
const double _barPaddingV = 18.0;
const double _barMinHeight = 90.0;
const double _primaryButtonHeight = 50.0;
const double _primaryPressScale = 0.96;
const double _frostOpacity = 0.88;
const double _blurSigma = 12.0;

/// Premium floating bottom action bar for detail screens.
/// Frosted glass, clear hierarchy: favorite · price · primary CTA.
/// Optional secondary (e.g. chat) as icon-only so it doesn't compete.
class DetailBottomBar extends StatefulWidget {
  const DetailBottomBar({
    super.key,
    this.showFavorite = true,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.price,
    this.priceSuffix,
    this.primaryLabel,
    this.onPrimaryTap,
    this.primaryEnabled = true,
    this.secondaryLabel,
    this.onSecondaryTap,
  });

  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final double? price;
  final String? priceSuffix;
  final String? primaryLabel;
  final VoidCallback? onPrimaryTap;
  final bool primaryEnabled;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryTap;

  @override
  State<DetailBottomBar> createState() => _DetailBottomBarState();
}

class _DetailBottomBarState extends State<DetailBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_slideController);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveSuffix = widget.priceSuffix ?? l10n.priceFrom;
    final effectivePrimary = widget.primaryLabel ?? l10n.bookNow;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(minHeight: _barMinHeight),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_barTopRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: _barElevation,
                    offset: const Offset(0, -4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_barTopRadius),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      _barPaddingH,
                      _barPaddingV,
                      _barPaddingH,
                      _barPaddingV,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: _frostOpacity),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.showFavorite) ...[
                            _FavoriteButton(
                              isFavorite: widget.isFavorite,
                              onTap: widget.onFavoriteTap,
                            ),
                            const SizedBox(width: 16),
                          ],
                          if (widget.price != null) ...[
                            Expanded(
                              child: _PriceBlock(
                                price: widget.price!,
                                suffix: effectiveSuffix,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ] else
                            const Spacer(),
                          if (widget.secondaryLabel != null &&
                              widget.onSecondaryTap != null) ...[
                            _SecondaryIconButton(
                              onTap: widget.onSecondaryTap!,
                              icon: Icons.chat_bubble_outline,
                            ),
                            const SizedBox(width: 12),
                          ],
                          _PrimaryCtaButton(
                            label: effectivePrimary,
                            enabled: widget.primaryEnabled,
                            onTap: widget.onPrimaryTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({
    required this.isFavorite,
    this.onTap,
  });

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isFavorite
                ? AppTheme.primaryColor.withValues(alpha: 0.12)
                : AppTheme.textSecondary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 22,
            color: widget.isFavorite
                ? AppTheme.primaryColor
                : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.price, required this.suffix});

  final double price;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PriceWidget(
          price: price,
          prefix: '¥',
          showFrom: false,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE53935),
          ),
        ),
        if (suffix.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              suffix,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _SecondaryIconButton extends StatefulWidget {
  const _SecondaryIconButton({required this.onTap, required this.icon});

  final VoidCallback onTap;
  final IconData icon;

  @override
  State<_SecondaryIconButton> createState() => _SecondaryIconButtonState();
}

class _SecondaryIconButtonState extends State<_SecondaryIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 22,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

class _PrimaryCtaButton extends StatefulWidget {
  const _PrimaryCtaButton({
    required this.label,
    required this.enabled,
    this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  State<_PrimaryCtaButton> createState() => _PrimaryCtaButtonState();
}

class _PrimaryCtaButtonState extends State<_PrimaryCtaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: enabled
          ? () {
              HapticFeedback.mediumImpact();
              widget.onTap?.call();
            }
          : null,
      child: AnimatedScale(
        scale: (enabled && _pressed) ? _primaryPressScale : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: _primaryButtonHeight,
          constraints: const BoxConstraints(minWidth: 140),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_primaryButtonHeight / 2),
            gradient: enabled
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppTheme.primaryGradient,
                  )
                : null,
            color: enabled
                ? null
                : AppTheme.textSecondary.withValues(alpha: 0.25),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 20,
                color: enabled ? Colors.white : Colors.white70,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: enabled ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
