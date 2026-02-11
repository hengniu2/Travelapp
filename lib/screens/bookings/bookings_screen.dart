import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../widgets/price_widget.dart';
import 'hotels_screen.dart';
import 'tickets_screen.dart';
import 'insurance_screen.dart';
import '../profile/orders_screen.dart';
import '../profile/favorites_screen.dart';

/// Booking (预订) hub. Reference-style: branded hero, white content surface, clear section separation.
/// No full-screen or section photo backgrounds. Hero = gradient + wave; content = elevated white sheet.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  static const double _cardRadius = 20;
  static const double _padding = 18;
  static const double _contentSurfaceRadius = 24;
  static const double _heroHeight = 200;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          _buildHero(context, theme, l10n),
          SliverToBoxAdapter(
            child: _buildContentSurface(context, theme, l10n),
          ),
        ],
      ),
    );
  }

  /// Branded hero: green gradient, soft wave bottom, centered title. No photography.
  Widget _buildHero(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: _heroHeight + MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            ClipPath(
              clipper: _WaveHeroClipper(),
              child: Container(
                width: double.infinity,
                height: _heroHeight + MediaQuery.of(context).padding.top,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryDark,
                      const Color(0xFF00897B),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(),
                size: Size.infinite,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top * 0.5),
                  child: Text(
                    l10n.bookings,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// White content surface: rounded top, elevation, holds all booking sections.
  Widget _buildContentSurface(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(_contentSurfaceRadius)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(_padding, 24, _padding, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceCard(context, theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, '预订分类'),
            const SizedBox(height: 12),
            _buildCategoryCards(context, theme, l10n),
            const SizedBox(height: 28),
            _buildSectionTitle(theme, '快捷预订'),
            const SizedBox(height: 12),
            _buildQuickBookingSection(context, theme),
            const SizedBox(height: 28),
            _buildSectionTitle(theme, '我的'),
            const SizedBox(height: 12),
            _buildSmartFeatures(context, theme, l10n),
          ],
        ),
      ),
    );
  }

  /// 预订服务: soft card with subtle green tint. No photo background.
  Widget _buildServiceCard(BuildContext context, ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: primary.withValues(alpha: 0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.calendar_today_rounded, color: primary, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '预订服务',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '酒店 / 门票 / 保险 / 交通',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 预订分类: clean surface, no section background image. Floating cards only.
  Widget _buildCategoryCards(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final categories = [
      _CategoryItem(l10n.hotels, '精选低价', Icons.hotel_rounded, AppTheme.categoryBlue, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HotelsScreen()));
      }),
      _CategoryItem(l10n.tickets, '热门景点', Icons.confirmation_number_rounded, AppTheme.categoryOrange, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketsScreen()));
      }),
      _CategoryItem(l10n.insurance, '出行保障', Icons.shield_rounded, AppTheme.categoryGreen, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const InsuranceScreen()));
      }),
      _CategoryItem('交通', '接送/包车', Icons.directions_car_rounded, AppTheme.categoryPurple, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.viewMore), behavior: SnackBarBehavior.floating),
        );
      }),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.65,
      children: categories.map((c) => _CategoryCard(theme: theme, item: c)).toList(),
    );
  }

  Widget _buildQuickBookingSection(BuildContext context, ThemeData theme) {
    final items = [
      _QuickItem('上海外滩酒店', 688, Icons.hotel_rounded, AppTheme.categoryBlue),
      _QuickItem('故宫门票', 60, Icons.confirmation_number_rounded, AppTheme.categoryOrange),
      _QuickItem('三亚自由行', 1299, Icons.beach_access_rounded, AppTheme.categoryGreen),
    ];
    const tags = ['最近预订', '热门推荐', '今日特价'];
    return SizedBox(
      height: 152,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < items.length - 1 ? 12 : 0),
            child: _QuickCard(theme: theme, item: items[index], tag: tags[index]),
          );
        },
      ),
    );
  }

  Widget _buildSmartFeatures(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SmartCard(
                theme: theme,
                icon: Icons.receipt_long_rounded,
                title: l10n.myOrders,
                subtitle: l10n.viewOrders,
                color: AppTheme.categoryBlue,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SmartCard(
                theme: theme,
                icon: Icons.favorite_rounded,
                title: l10n.favorites,
                subtitle: l10n.viewFavorites,
                color: AppTheme.categoryPink,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _DiscountCard(
          theme: theme,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.promotionsComingSoon), behavior: SnackBarBehavior.floating),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _CategoryItem(this.title, this.subtitle, this.icon, this.color, this.onTap);
}

class _CategoryCard extends StatelessWidget {
  final ThemeData theme;
  final _CategoryItem item;

  const _CategoryCard({required this.theme, required this.item});

  @override
  Widget build(BuildContext context) {
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickItem {
  final String title;
  final double price;
  final IconData icon;
  final Color color;
  _QuickItem(this.title, this.price, this.icon, this.color);
}

/// Quick booking card: no background image. Colored header + content for strong contrast.
class _QuickCard extends StatelessWidget {
  final ThemeData theme;
  final _QuickItem item;
  final String tag;

  const _QuickCard({required this.theme, required this.item, required this.tag});

  @override
  Widget build(BuildContext context) {
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    return SizedBox(
      width: 164,
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 88,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(BookingsScreen._cardRadius)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(item.icon, color: item.color.withValues(alpha: 0.6), size: 40),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 164 - 24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    PriceWidget(
                      price: item.price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartCard extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SmartCard({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceVariant),
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

class _DiscountCard extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onTap;

  const _DiscountCard({required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BookingsScreen._cardRadius),
            color: AppTheme.categoryOrange.withValues(alpha: 0.08),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.categoryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.local_offer_rounded, color: AppTheme.categoryOrange, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '优惠 / 折扣',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '限时特惠，领券立减',
                      style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: onSurfaceVariant, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Soft wave clipper for hero bottom edge — smooth curve into content surface.
class _WaveHeroClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.5, size.height - 28, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Very low-opacity abstract pattern on hero (no photography). Circles/lines only.
class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const spacing = 48.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), 12, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
