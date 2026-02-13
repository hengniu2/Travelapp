import 'package:flutter/material.dart';
import '../../models/booking_traveler.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import 'payment_selection_screen.dart';

/// 填写出行人信息：姓名、身份证、手机号。支持添加多名随行人员。
/// 下一步进入付款选择（支付宝/微信支付）。
class GuestInfoScreen extends StatefulWidget {
  /// 'tour' | 'hotel'
  final String bookingType;
  final String itemId;
  final String itemName;
  final double amount;
  final Map<String, dynamic> extraDetails;
  final String? prefilledPhone;

  const GuestInfoScreen({
    super.key,
    required this.bookingType,
    required this.itemId,
    required this.itemName,
    required this.amount,
    required this.extraDetails,
    this.prefilledPhone,
  });

  @override
  State<GuestInfoScreen> createState() => _GuestInfoScreenState();
}

class _GuestInfoScreenState extends State<GuestInfoScreen> {
  final List<_TravelerFormData> _travelers = [];

  @override
  void initState() {
    super.initState();
    _travelers.add(_TravelerFormData(
      name: '',
      idCard: '',
      phone: widget.prefilledPhone ?? '',
    ));
  }

  void _addTraveler() {
    setState(() {
      _travelers.add(_TravelerFormData(name: '', idCard: '', phone: ''));
    });
  }

  void _removeTraveler(int index) {
    if (_travelers.length <= 1) return;
    _travelers[index].dispose();
    setState(() => _travelers.removeAt(index));
  }

  List<BookingTraveler>? _validateAndCollect() {
    final l10n = AppLocalizations.of(context)!;
    final list = <BookingTraveler>[];
    for (int i = 0; i < _travelers.length; i++) {
      final t = _travelers[i];
      final name = t.nameController.text.trim();
      final idCard = t.idCardController.text.trim();
      final phone = t.phoneController.text.trim();
      if (name.isEmpty || idCard.isEmpty || phone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.travelerInfoRequired), behavior: SnackBarBehavior.floating),
        );
        return null;
      }
      list.add(BookingTraveler(name: name, idCard: idCard, phone: phone));
    }
    return list;
  }

  void _goToPayment() {
    final travelers = _validateAndCollect();
    if (travelers == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSelectionScreen(
          bookingType: widget.bookingType,
          itemId: widget.itemId,
          itemName: widget.itemName,
          amount: widget.amount,
          extraDetails: widget.extraDetails,
          travelers: travelers,
        ),
      ),
    ).then((result) {
      if (mounted) Navigator.pop(context, result);
    });
  }

  @override
  void dispose() {
    for (final t in _travelers) {
      t.nameController.dispose();
      t.idCardController.dispose();
      t.phoneController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fillTravelerInfo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.fillTravelerInfo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.travelerInfoRequired,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(_travelers.length, (index) {
              final t = _travelers[index];
              return _TravelerCard(
                index: index,
                data: t,
                l10n: l10n,
                canRemove: _travelers.length > 1,
                onRemove: () => _removeTraveler(index),
              );
            }),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _addTraveler,
              icon: const Icon(Icons.person_add),
              label: Text(l10n.addTraveler),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
          child: ElevatedButton(
            onPressed: _goToPayment,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(l10n.nextStep),
          ),
        ),
      ),
    );
  }
}

class _TravelerFormData {
  final TextEditingController nameController;
  final TextEditingController idCardController;
  final TextEditingController phoneController;

  _TravelerFormData({
    required String name,
    required String idCard,
    required String phone,
  })  : nameController = TextEditingController(text: name),
        idCardController = TextEditingController(text: idCard),
        phoneController = TextEditingController(text: phone);

  void dispose() {
    nameController.dispose();
    idCardController.dispose();
    phoneController.dispose();
  }
}

class _TravelerCard extends StatelessWidget {
  final int index;
  final _TravelerFormData data;
  final AppLocalizations l10n;
  final bool canRemove;
  final VoidCallback onRemove;

  const _TravelerCard({
    required this.index,
    required this.data,
    required this.l10n,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.travelerName} ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (canRemove)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: data.nameController,
              decoration: InputDecoration(
                labelText: l10n.travelerName,
                hintText: l10n.hintDisplayName,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: data.idCardController,
              decoration: InputDecoration(
                labelText: l10n.idCardNumber,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: data.phoneController,
              decoration: InputDecoration(
                labelText: l10n.travelerPhone,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
