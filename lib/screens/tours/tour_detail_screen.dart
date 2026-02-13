import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/tour.dart';
import '../../models/review.dart';
import '../../services/data_service.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/detail_bottom_bar.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/tag_localizations.dart';
import 'tour_select_options_screen.dart';
import 'tour_gallery_screen.dart';

// Premium detail design system (8px grid, spec spacing/radius/shadow)
const double _paddingH = 16.0;
const double _sectionSpacing = 24.0;
const double _cardRadius = 18.0;
const double _tagRadius = 12.0;
const double _heroBottomRadius = 22.0;
const BoxShadow _cardShadow = BoxShadow(
  color: Color(0x0F000000),
  blurRadius: 16,
  offset: Offset(0, 4),
);

class TourDetailScreen extends StatelessWidget {
  final Tour tour;

  const TourDetailScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final locale = Localizations.localeOf(context).toString();
    final isZh = locale.startsWith('zh');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ─── 1. Hero: 16:9, rounded bottom, gradient, title + subtitle, floating actions ───
              SliverToBoxAdapter(
                child: _buildHero(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(_paddingH, 0, _paddingH, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: _sectionSpacing),
                    // ─── 2. Quick Info Card ─────────────────────────────────────
                    _buildQuickInfoCard(context),
                    const SizedBox(height: _sectionSpacing),
                    // ─── 2b. Photo gallery strip ───────────────────────────────
                    _buildGalleryStrip(context),
                    const SizedBox(height: _sectionSpacing),
                    // ─── 3. 图文介绍 (Image + text storytelling) ─────────────────
                    _buildIntroSection(context, isZh),
                    const SizedBox(height: _sectionSpacing),
                    // ─── 4. 日程介绍 (Day-by-day itinerary cards) ───────────────
                    _buildItinerarySection(context, isZh),
                    const SizedBox(height: _sectionSpacing),
                    // ─── 5. Inclusion / Exclusion (icon lists) ─────────────────
                    _buildInclusionExclusionSection(context),
                    const SizedBox(height: _sectionSpacing),
                    // ─── 6. Important information ─────────────────────────────
                    _buildImportantInfoSection(context),
                    const SizedBox(height: _sectionSpacing),
                    // ─── 7. Reviews ───────────────────────────────────────────
                    _buildReviewsSection(context),
                    const SizedBox(height: _sectionSpacing),
                    // ─── 8. Similar tours ─────────────────────────────────────
                    _buildSimilarToursSection(context),
                    const SizedBox(height: _sectionSpacing * 2),
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
              isFavorite: appProvider.isFavorite(tour.id),
              onFavoriteTap: () => appProvider.toggleFavorite(tour.id),
              price: tour.price,
              priceSuffix: l10n.priceFrom,
              primaryLabel: l10n.book,
              onPrimaryTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TourSelectOptionsScreen(tour: tour),
                  ),
                );
              },
              primaryEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.of(context).padding.top;
    final imageUrl = tour.image ?? TravelImages.getTourImage(tour.hashCode);
    final isNetwork = imageUrl.startsWith('http');

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(_heroBottomRadius)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isNetwork)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                cacheWidth: 800,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _heroImagePlaceholder(context, imageUrl);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _heroImagePlaceholder(context, imageUrl);
                },
              )
            else
              Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _heroImagePlaceholder(context, imageUrl),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _localizedTitle(context),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.25,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 1))],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _localizedSubtitle(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: topPadding + 8,
              left: 8,
              child: _iconButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: topPadding + 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tour.isTrending) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.categoryRed, AppTheme.categoryOrange],
                        ),
                        borderRadius: BorderRadius.circular(_tagRadius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            l10n.hot,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  _iconButton(
                    icon: Icons.share_outlined,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.sharedTo(l10n.wechat))),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Consumer<AppProvider>(
                    builder: (context, provider, _) => _iconButton(
                      icon: provider.isFavorite(tour.id) ? Icons.favorite : Icons.favorite_border,
                      onTap: () => provider.toggleFavorite(tour.id),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroImagePlaceholder(BuildContext context, String fallbackImageUrl) {
    return TravelImages.buildImageBackground(
      imageUrl: fallbackImageUrl,
      opacity: 0.5,
      cacheWidth: 800,
      child: const SizedBox.expand(),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildQuickInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final departure = tour.route.isNotEmpty
        ? TagLocalizations.destination(l10n.localeName, tour.route.first)
        : '—';
    final highlightTags = tour.route.take(4).map((r) => TagLocalizations.destination(l10n.localeName, r)).toList();
    if (highlightTags.isEmpty) highlightTags.add(l10n.itineraryDuration);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [_cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _quickInfoChip(Icons.schedule, l10n.days(tour.duration), AppTheme.categoryOrange),
              _quickInfoChip(Icons.location_on_outlined, departure, AppTheme.categoryBlue),
              _quickInfoChip(Icons.people_outline, '${tour.maxParticipants} ${l10n.peopleUnit}', AppTheme.categoryPurple),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                l10n.highlights,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              ...highlightTags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(_tagRadius),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 14),
          RatingWidget(rating: tour.rating, reviewCount: tour.reviewCount),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                l10n.referencePrice,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              PriceWidget(
                price: tour.price,
                showFrom: true,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.categoryRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickInfoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryStrip(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final images = TravelImages.getTourGalleryImages(tour.hashCode, count: 8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.tourPhotos,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TourGalleryScreen(
                      imageUrls: images,
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: Text(
                l10n.viewAllPhotos,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final url = images[index];
              final isNetwork = url.startsWith('http');
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TourGalleryScreen(
                        imageUrls: images,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 140,
                    child: isNetwork
                        ? Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _smallImagePlaceholder())
                        : Image.asset(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _smallImagePlaceholder()),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _smallImagePlaceholder() {
    return Container(
      color: AppTheme.backgroundColor,
      child: const Icon(Icons.image_outlined, size: 36, color: AppTheme.textTertiary),
    );
  }

  Widget _buildIntroSection(BuildContext context, bool isZh) {
    final l10n = AppLocalizations.of(context)!;
    final description = isZh ? (tour.descriptionZh ?? tour.description) : tour.description;
    final paragraphs = description.split(RegExp(r'\n\n+')).where((s) => s.trim().isNotEmpty).toList();
    if (paragraphs.isEmpty) paragraphs.add(description);
    final firstImageUrl = tour.image ?? TravelImages.getTourImage(tour.hashCode);
    final secondImageUrl = TravelImages.getTourImage(tour.hashCode + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.itineraryIntro,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(_cardRadius),
          child: _buildIntroImage(firstImageUrl),
        ),
        const SizedBox(height: 16),
        Text(
          _localizedTitle(context),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          paragraphs.first.trim(),
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: AppTheme.textSecondary,
          ),
        ),
        if (paragraphs.length > 2) ...[
          const SizedBox(height: 12),
          Text(
            paragraphs[1].trim(),
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tour.route.take(3).map((r) {
            final tag = TagLocalizations.destination(l10n.localeName, r);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(_tagRadius),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }).toList(),
        ),
        if (paragraphs.length > 1) ...[
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(_cardRadius),
            child: _buildIntroImage(secondImageUrl),
          ),
          const SizedBox(height: 16),
          Text(
            paragraphs.length > 2 ? paragraphs[2].trim() : paragraphs[1].trim(),
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIntroImage(String url) {
    final isNetwork = url.startsWith('http');
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: isNetwork
          ? Image.network(
              url,
              fit: BoxFit.cover,
              cacheWidth: 800,
              errorBuilder: (_, __, ___) => _placeholderImage(url),
            )
          : Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderImage(url),
            ),
    );
  }

  Widget _placeholderImage(String fallback) {
    return TravelImages.buildImageBackground(
      imageUrl: fallback,
      opacity: 0.6,
      cacheWidth: 800,
      child: const Center(child: Icon(Icons.image_outlined, size: 48, color: Colors.white70)),
    );
  }

  Widget _buildItinerarySection(BuildContext context, bool isZh) {
    final l10n = AppLocalizations.of(context)!;
    if (tour.route.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.itinerarySchedule,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...tour.route.asMap().entries.map((entry) {
          final dayIndex = entry.key + 1;
          final destination = TagLocalizations.destination(l10n.localeName, entry.value);
          final isLast = dayIndex == tour.route.length;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildDayCard(
              context,
              dayNumber: dayIndex,
              destination: destination,
              summary: _daySummary(l10n, dayIndex),
              activities: [_activity(l10n, 'Morning'), _activity(l10n, 'Afternoon')],
              isLast: isLast,
            ),
          );
        }),
      ],
    );
  }

  String _daySummary(AppLocalizations l10n, int day) {
    return '${l10n.itineraryRoute} · ${l10n.days(1)}';
  }

  String _activity(AppLocalizations l10n, String period) {
    return period == 'Morning' ? l10n.activityMorning : l10n.activityAfternoon;
  }

  Widget _buildDayCard(
    BuildContext context, {
    required int dayNumber,
    required String destination,
    required String summary,
    required List<String> activities,
    required bool isLast,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$dayNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
              boxShadow: [_cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dayNumber(dayNumber),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                ...activities.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.schedule, size: 16, color: AppTheme.categoryOrange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              a,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInclusionExclusionSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tour.packageDetails != null && tour.packageDetails!.isNotEmpty) ...[
          Text(
            l10n.included,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
              boxShadow: [_cardShadow],
            ),
            child: Column(
              children: tour.packageDetails!.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (e.value.toString().trim().isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                e.value.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: _sectionSpacing),
        ],
        Text(
          l10n.notIncluded,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: [_cardShadow],
          ),
          child: Column(
            children: [
              _exclusionRow(Icons.cancel_outlined, l10n.notIncludedPersonalExpenses),
              const SizedBox(height: 10),
              _exclusionRow(Icons.cancel_outlined, l10n.notIncludedTravelInsurance),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImportantInfoSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.importantInfo,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: [_cardShadow],
          ),
          child: Column(
            children: [
              _infoRow(Icons.badge_outlined, l10n.visaInfo, l10n.visaInfoDetail),
              const SizedBox(height: 14),
              _infoRow(Icons.luggage_outlined, l10n.whatToBring, l10n.whatToBringDetail),
              const SizedBox(height: 14),
              _infoRow(Icons.lightbulb_outline, l10n.travelTips, l10n.travelTipsDetail),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reviews = DataService().getReviewsForTour(tour.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.reviews,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              l10n.reviewCountWithNumber(tour.reviewCount),
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: [_cardShadow],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    tour.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.star, color: AppTheme.categoryOrange, size: 28),
                ],
              ),
              const SizedBox(height: 16),
              if (reviews.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l10n.noReviewsYet,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                )
              else
                ...reviews.take(4).map((r) => _buildReviewTile(context, r)),
              if (reviews.length > 4)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      l10n.seeAllReviews,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewTile(BuildContext context, Review review) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final localeString = locale.countryCode != null && locale.countryCode!.isNotEmpty
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    final dateStr = DateFormat.yMMMd(localeString).format(review.date);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            child: Text(
              _localizedReviewName(context, review).isNotEmpty
                  ? _localizedReviewName(context, review)[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _localizedReviewName(context, review),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: AppTheme.categoryOrange),
                        const SizedBox(width: 2),
                        Text(
                          review.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _localizedReviewComment(context, review),
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localizedReviewName(BuildContext context, Review review) {
    final l10n = AppLocalizations.of(context)!;
    switch (review.id) {
      case '1': return l10n.reviewUserName1;
      case '2': return l10n.reviewUserName2;
      case 't3': return l10n.reviewUserName3;
      case 't4': return l10n.reviewUserName4;
      case 't5': return l10n.reviewUserName5;
      default: return review.userName;
    }
  }

  String _localizedReviewComment(BuildContext context, Review review) {
    final l10n = AppLocalizations.of(context)!;
    switch (review.id) {
      case '1': return l10n.reviewComment1;
      case '2': return l10n.reviewComment2;
      case 't3': return l10n.reviewComment3;
      case 't4': return l10n.reviewComment4;
      case 't5': return l10n.reviewComment5;
      default: return review.comment;
    }
  }

  Widget _buildSimilarToursSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final similar = DataService().getSimilarTours(tour.id, limit: 4);
    if (similar.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.similarTours,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final t = similar[index];
              final title = l10n.localeName == 'zh' ? (t.titleZh ?? t.title) : t.title;
              final imageUrl = t.image ?? TravelImages.getTourImage(t.hashCode);
              final isNetwork = imageUrl.startsWith('http');
              return SizedBox(
                width: 160,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TourDetailScreen(tour: t),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(_cardRadius),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(_cardRadius),
                        boxShadow: [_cardShadow],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: isNetwork
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _smallImagePlaceholder(),
                                  )
                                : Image.asset(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _smallImagePlaceholder(),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.star, size: 14, color: AppTheme.categoryOrange),
                                    const SizedBox(width: 4),
                                    Text(
                                      t.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const Spacer(),
                                    PriceWidget(
                                      price: t.price,
                                      showFrom: false,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.categoryRed,
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
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _exclusionRow(IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppTheme.textTertiary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _localizedTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.localeName == 'zh' ? (tour.titleZh ?? tour.title) : tour.title;
  }

  String _localizedSubtitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final duration = l10n.days(tour.duration);
    final routeType = _routeTypeLabel(context, tour.routeType);
    return '$duration · $routeType';
  }

  static String _routeTypeLabel(BuildContext context, String routeType) {
    final l10n = AppLocalizations.of(context)!;
    switch (routeType) {
      case 'Multi-City':
        return l10n.routeTypeMultiCity;
      case 'City Tour':
        return l10n.routeTypeCityTour;
      case 'Cruise':
        return l10n.routeTypeCruise;
      default:
        return routeType;
    }
  }
}
