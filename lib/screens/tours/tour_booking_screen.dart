import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/tour.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../bookings/guest_info_screen.dart';

/// 填写订单 — Fill in Order. Rich UI: tour summary card, travelers stepper,
/// add traveler button, room selection, contact, total and submit.
class TourBookingScreen extends StatefulWidget {
  final Tour tour;
  final DateTime? selectedDepartureDate;
  final int? adults;
  final int? children;
  final double? pricePerDeparture;

  const TourBookingScreen({
    super.key,
    required this.tour,
    this.selectedDepartureDate,
    this.adults,
    this.children,
    this.pricePerDeparture,
  });

  @override
  State<TourBookingScreen> createState() => _TourBookingScreenState();
}

class _TourBookingScreenState extends State<TourBookingScreen> {
  late int _adults;
  late int _children;
  DateTime get _departureDate => widget.selectedDepartureDate ?? widget.tour.startDate;
  DateTime get _endDate => _departureDate.add(Duration(days: widget.tour.duration));
  double get _pricePerPerson => widget.pricePerDeparture ?? widget.tour.price;
  double get _totalAmount => _pricePerPerson * _adults + (_pricePerPerson * 0.6) * _children;

  double _roomCount = 0.5;
  final TextEditingController _contactNameController = TextEditingController();
  static const int _spotsLeft = 6;

  @override
  void initState() {
    super.initState();
    _adults = widget.adults ?? 1;
    _children = widget.children ?? 0;
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    super.dispose();
  }

  void _goToGuestInfo(BuildContext context) {
    final name = _contactNameController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterContactName),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final title = l10n.localeName == 'zh'
        ? (widget.tour.titleZh ?? widget.tour.title)
        : widget.tour.title;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuestInfoScreen(
          bookingType: 'tour',
          itemId: widget.tour.id,
          itemName: title,
          amount: _totalAmount,
          extraDetails: {
            'startDate': _departureDate.toIso8601String(),
            'endDate': _endDate.toIso8601String(),
            'duration': widget.tour.duration,
            'participants': _adults + _children,
            'adults': _adults,
            'children': _children,
            'contactName': name,
            'rooms': _roomCount,
          },
          prefilledPhone: appProvider.currentUser?.phone,
        ),
      ),
    ).then((result) {
      if (result == true && mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final title = l10n.localeName == 'zh'
        ? (widget.tour.titleZh ?? widget.tour.title)
        : widget.tour.title;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          l10n.fillOrder,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _dateChip(
                        l10n.departureDate,
                        DateFormat.Md(locale).format(_departureDate) +
                            ' ${DateFormat.E(locale).format(_departureDate)}',
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.tour.duration}${l10n.localeName == 'zh' ? '天' : 'd'}${widget.tour.duration - 1}${l10n.localeName == 'zh' ? '晚' : 'n'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _dateChip(
                        l10n.endDate,
                        DateFormat.Md(locale).format(_endDate) +
                            ' ${DateFormat.E(locale).format(_endDate)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.itineraryPackage}: $title',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.confirmWithin24h,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.numberOfTravelers,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.adults12AndAbove,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              '¥${_pricePerPerson.toStringAsFixed(0)}${l10n.perPerson}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        l10n.spotsLeft(_spotsLeft),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _stepperInt(
                        value: _adults,
                        onMinus: _adults > 1 ? () => setState(() => _adults--) : null,
                        onPlus: _adults < 9 ? () => setState(() => _adults++) : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.needSelectAdultTravelers(_adults),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.ensureInfoMatchesId,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _goToGuestInfo(context);
                      },
                      icon: Icon(Icons.add, color: AppTheme.primaryColor, size: 20),
                      label: Text(
                        l10n.addTravelerButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.numberOfRooms,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Icon(Icons.help_outline, size: 18, color: Colors.grey.shade600),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _stepperButton(
                        minus: true,
                        onPressed: _roomCount > 0.5
                            ? () => setState(() => _roomCount -= 0.5)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _roomCount == _roomCount.roundToDouble()
                              ? '${_roomCount.toInt()}'
                              : _roomCount.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _stepperButton(
                        minus: false,
                        onPressed: _roomCount < 10
                            ? () => setState(() => _roomCount += 0.5)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.red.shade400),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.roomSharingInfo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.roomSharingSelect,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.contactPerson,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contactNameController,
                    decoration: InputDecoration(
                      hintText: l10n.enterContactName,
                      labelText: l10n.realNameRequired,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(l10n),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _dateChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _stepperInt({
    required int value,
    required VoidCallback? onMinus,
    required VoidCallback? onPlus,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepperButton(minus: true, onPressed: onMinus),
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
        _stepperButton(minus: false, onPressed: onPlus),
      ],
    );
  }

  Widget _stepperButton({required bool minus, required VoidCallback? onPressed}) {
    final canTap = onPressed != null;
    return Material(
      color: canTap
          ? AppTheme.primaryColor.withValues(alpha: 0.12)
          : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            minus ? Icons.remove : Icons.add,
            size: 20,
            color: canTap ? AppTheme.primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.totalAmount}:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              PriceWidget(
                price: _totalAmount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => _goToGuestInfo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(l10n.submitOrder),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
