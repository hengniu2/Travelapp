import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/ticket.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/image_first_card.dart';
import '../../widgets/ios_bottom_sheet.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../l10n/app_localizations.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final DataService _dataService = DataService();
  List<Ticket> _tickets = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTickets() {
    _tickets = _dataService.getTickets();
  }

  void _bookTicket(Ticket ticket) {
    showIosActionSheet(
      context,
      title: '${ticket.name} · ¥${ticket.price.toStringAsFixed(0)}',
      cancelLabel: AppLocalizations.of(context)!.cancel,
      actions: [
        IosSheetAction(
          icon: Icons.account_balance_wallet,
          label: AppLocalizations.of(context)!.wallet,
          onTap: () => _processPayment(ticket, 'wallet'),
          color: AppTheme.primaryColor,
        ),
        IosSheetAction(
          icon: Icons.credit_card,
          label: AppLocalizations.of(context)!.creditCard,
          onTap: () => _processPayment(ticket, 'card'),
          color: AppTheme.categoryBlue,
        ),
      ],
    );
  }

  void _processPayment(Ticket ticket, String method) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'ticket',
      itemId: ticket.id,
      itemName: ticket.name,
      amount: ticket.price,
      orderDate: DateTime.now(),
      status: 'confirmed',
      details: {
        'location': ticket.location,
        'type': ticket.type,
        'paymentMethod': method,
      },
    );

    appProvider.addOrder(order);

    if (method == 'wallet') {
      appProvider.deductFromWallet(ticket.price);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.ticketBookedSuccess),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.attractionTickets),
      ),
      body: Column(
        children: [
          // Search bar with image background
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppDesignSystem.borderRadiusImage,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.categoryOrange.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchTickets,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.categoryOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 20),
                ),
                border: OutlineInputBorder(
                  borderRadius: AppDesignSystem.borderRadiusImage,
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tickets.length,
              itemBuilder: (context, index) {
                final ticket = _tickets[index];
                final matchesSearch = _searchController.text.isEmpty ||
                    ticket.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    ticket.location
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase());

                if (!matchesSearch) return const SizedBox.shrink();

                final typeColors = {
                  'Museum': AppTheme.categoryPurple,
                  'Theme Park': AppTheme.categoryPink,
                  'Monument': AppTheme.categoryOrange,
                  'Nature': AppTheme.categoryGreen,
                };
                final typeColor = typeColors[ticket.type] ?? AppTheme.categoryOrange;

                return ImageFirstCard(
                  onTap: () => _bookTicket(ticket),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppDesignSystem.radiusImage)),
                            child: SizedBox(
                              height: 160,
                              width: double.infinity,
                              child: TravelImages.buildImageBackground(
                                imageUrl: ticket.image ??
                                    TravelImages.getTourImage(ticket.hashCode),
                                opacity: 0.0,
                                cacheWidth: 600,
                                child: const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: AppDesignSystem.spacingMd,
                            right: AppDesignSystem.spacingMd,
                            child: CardBadge(
                              label: ticket.type,
                              color: typeColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppDesignSystem.spacingSm),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: AppTheme.categoryBlue),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    ticket.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.categoryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDesignSystem.spacingMd),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PriceWidget(
                                  price: ticket.price,
                                  prefix: '¥',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.categoryRed,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: AppTheme.sunsetGradient),
                                    borderRadius:
                                        AppDesignSystem.borderRadiusSm,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.book_online,
                                          color: Colors.white, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Book',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

