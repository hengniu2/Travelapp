import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_design_system.dart';

/// Shimmer gradient for skeleton loading.
class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({
    required this.progress,
    required this.baseColor,
    required this.highlightColor,
  });

  final double progress;
  final Color baseColor;
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment(-1.0 + progress * 2, 0),
      end: Alignment(1.0 + progress * 2, 0),
      colors: [baseColor, highlightColor, baseColor],
      stops: const [0.0, 0.5, 1.0],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Single skeleton placeholder (rounded rect).
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return _Skeleton(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? AppDesignSystem.borderRadiusSm,
        ),
      ),
    );
  }
}

/// Wraps a child with shimmer overlay (use with white/opaque placeholder shapes).
class _Skeleton extends StatefulWidget {
  const _Skeleton({required this.child});

  final Widget child;

  @override
  State<_Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<_Skeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: AppDesignSystem.borderRadiusSm,
          child: Stack(
            children: [
              child!,
              Positioned.fill(
                child: CustomPaint(
                  painter: _ShimmerPainter(
                    progress: _animation.value,
                    baseColor: AppTheme.textTertiary.withValues(alpha: 0.08),
                    highlightColor: AppTheme.textTertiary.withValues(alpha: 0.18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Skeleton card matching image-first card layout (image area + title + price line).
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppDesignSystem.borderRadiusLg,
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
          SkeletonBox(
            height: 180,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDesignSystem.radiusImage),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: double.infinity, height: 20),
                const SizedBox(height: AppDesignSystem.spacingSm),
                SkeletonBox(width: 120, height: 14),
                const SizedBox(height: AppDesignSystem.spacingMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonBox(width: 80, height: 24),
                    SkeletonBox(width: 60, height: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List of skeleton cards for list loading state.
class SkeletonCardList extends StatelessWidget {
  const SkeletonCardList({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacingLg),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (_, __) => const SkeletonCard(),
    );
  }
}
