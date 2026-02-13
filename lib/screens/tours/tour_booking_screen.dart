import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/tour.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import '../../l10n/app_localizations.dart';
import '../bookings/guest_info_screen.dart';

/// 旅行套餐预订：选择出发日期、人数 → 下一步填写出行人信息 → 选择支付方式（支付宝/微信）
class TourBookingScreen extends StatefulWidget {
  final Tour tour;

  const TourBookingScreen({super.key, required this.tour});

  @override
  State<TourBookingScreen> createState() => _TourBookingScreenState();
}

class _TourBookingScreenState extends State<TourBookingScreen> {
  int _participants = 1;
  DateTime get _startDate => widget.tour.startDate;

  void _goToGuestInfo(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuestInfoScreen(
          bookingType: 'tour',
          itemId: widget.tour.id,
          itemName: l10n.localeName == 'zh' ? (widget.tour.titleZh ?? widget.tour.title) : widget.tour.title,
          amount: widget.tour.price,
          extraDetails: {
            'startDate': _startDate.toIso8601String(),
            'duration': widget.tour.duration,
            'participants': _participants,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookTour),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.localeName == 'zh' ? (widget.tour.titleZh ?? widget.tour.title) : widget.tour.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.itineraryDuration}: ${l10n.days(widget.tour.duration)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.bookingInformation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(l10n.tourLabel, l10n.localeName == 'zh' ? (widget.tour.titleZh ?? widget.tour.title) : widget.tour.title),
                    const Divider(),
                    _buildInfoRow(
                      l10n.startDateLabel,
                      DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_startDate),
                    ),
                    const Divider(),
                    _buildInfoRow(l10n.itineraryDuration, l10n.days(widget.tour.duration)),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.participantsLabel, style: const TextStyle(color: Colors.grey)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _participants > 1 ? () => setState(() => _participants--) : null,
                            ),
                            Text('$_participants'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _participants++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.totalPriceLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PriceWidget(price: widget.tour.price),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => _goToGuestInfo(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(l10n.nextStep),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
