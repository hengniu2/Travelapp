import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/tour.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_theme.dart';
import '../../widgets/price_widget.dart';
import 'tour_booking_screen.dart';

/// Model for a selectable departure date with price and spots left.
class DepartureOption {
  final DateTime date;
  final double price;
  final int spotsLeft;
  DepartureOption({required this.date, required this.price, this.spotsLeft = 6});
}

/// 选择日期/套餐/人数 — Select date, package, and number of travelers (adults/children).
/// Matches client sample: travel package box, scrollable date cards, adult/child steppers, Next button.
class TourSelectOptionsScreen extends StatefulWidget {
  final Tour tour;

  const TourSelectOptionsScreen({super.key, required this.tour});

  @override
  State<TourSelectOptionsScreen> createState() => _TourSelectOptionsScreenState();
}

class _TourSelectOptionsScreenState extends State<TourSelectOptionsScreen> {
  int _selectedPackageIndex = 0;
  int _selectedDateIndex = 0;
  int _adults = 1;
  int _children = 0;

  List<String> _packageNames = [];
  List<DepartureOption> _departureDates = [];

  @override
  void initState() {
    super.initState();
    _departureDates = _buildDepartureDates();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_packageNames.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      final base = l10n.localeName == 'zh'
          ? (widget.tour.titleZh ?? widget.tour.title)
          : widget.tour.title;
      _packageNames = [base];
    }
  }

  List<DepartureOption> _buildDepartureDates() {
    final base = widget.tour.startDate;
    final prices = [widget.tour.price, widget.tour.price + 200, widget.tour.price + 300];
    return List.generate(14, (i) {
      final d = base.add(Duration(days: i));
      return DepartureOption(
        date: d,
        price: prices[i % 3],
        spotsLeft: 6,
      );
    });
  }

  void _onNext() {
    final opt = _departureDates[_selectedDateIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourBookingScreen(
          tour: widget.tour,
          selectedDepartureDate: opt.date,
          adults: _adults,
          children: _children,
          pricePerDeparture: opt.price,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final monthYear = DateFormat.yM(locale).format(_departureDates[_selectedDateIndex].date);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                l10n.selectDatePackageGuests,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(l10n.travelPackage),
                    const SizedBox(height: 10),
                    _buildPackageCard(l10n),
                    const SizedBox(height: 24),
                    _sectionTitle(l10n.departureDate),
                    const SizedBox(height: 8),
                    Text(
                      monthYear,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 112,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _departureDates.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _departureDates.length) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Center(
                                child: Text(
                                  l10n.allTourDates,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }
                          return _buildDateCard(l10n, index);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle(l10n.numberOfTravelers),
                    const SizedBox(height: 16),
                    _buildStepperRow(
                      label: l10n.adults12AndAbove,
                      value: _adults,
                      price: _departureDates[_selectedDateIndex].price,
                      onMinus: _adults > 1 ? () => setState(() => _adults--) : null,
                      onPlus: () => setState(() => _adults++),
                      l10n: l10n,
                    ),
                    const SizedBox(height: 16),
                    _buildStepperRow(
                      label: l10n.children2To12,
                      value: _children,
                      price: _departureDates[_selectedDateIndex].price * 0.6,
                      onMinus: _children > 0 ? () => setState(() => _children--) : null,
                      onPlus: () => setState(() => _children++),
                      l10n: l10n,
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(l10n),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildPackageCard(AppLocalizations l10n) {
    final selected = true;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor.withValues(alpha: 0.06) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _packageNames[_selectedPackageIndex],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(AppLocalizations l10n, int index) {
    final opt = _departureDates[index];
    final selected = _selectedDateIndex == index;
    final weekday = DateFormat.E(Localizations.localeOf(context).toString()).format(opt.date);
    final dateStr = DateFormat.Md().format(opt.date);

    return Padding(
      padding: EdgeInsets.only(right: index < _departureDates.length - 1 ? 12 : 0),
      child: GestureDetector(
        onTap: () => setState(() => _selectedDateIndex = index),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.primaryColor : Colors.grey.shade200,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weekday,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              PriceWidget(
                price: opt.price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.spotsLeft(opt.spotsLeft),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperRow({
    required String label,
    required int value,
    required double price,
    required VoidCallback? onMinus,
    required VoidCallback onPlus,
    required AppLocalizations l10n,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              PriceWidget(
                price: price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _stepperButton(
              icon: Icons.remove,
              onPressed: onMinus,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$value',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            _stepperButton(
              icon: Icons.add,
              onPressed: onPlus,
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepperButton({required IconData icon, required VoidCallback? onPressed}) {
    return Material(
      color: onPressed != null ? AppTheme.primaryColor.withValues(alpha: 0.12) : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 20,
            color: onPressed != null ? AppTheme.primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    final opt = _departureDates[_selectedDateIndex];
    final total = opt.price * _adults + (opt.price * 0.6) * _children;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.selected,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _packageNames[_selectedPackageIndex],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  l10n.departureDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(l10n.nextStep),
            ),
          ),
        ],
      ),
    );
  }
}
