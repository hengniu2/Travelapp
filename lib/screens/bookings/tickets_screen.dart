import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/ticket.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/travel_images.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book ${ticket.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${ticket.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Select payment method:'),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet'),
              onTap: () => _processPayment(ticket, 'wallet'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () => _processPayment(ticket, 'card'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _processPayment(Ticket ticket, String method) {
    Navigator.pop(context);

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
      const SnackBar(
        content: Text('Ticket booked successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Attraction Tickets'),
      ),
      body: Column(
        children: [
          // Search bar with image background
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                hintText: 'Search tickets...',
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
                  borderRadius: BorderRadius.circular(20),
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

                final gradient = TravelImages.getGradientForIndex(ticket.hashCode);
                final typeColors = {
                  'Museum': AppTheme.categoryPurple,
                  'Theme Park': AppTheme.categoryPink,
                  'Monument': AppTheme.categoryOrange,
                  'Nature': AppTheme.categoryGreen,
                };
                final typeColor = typeColors[ticket.type] ?? AppTheme.categoryOrange;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: typeColor.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _bookTicket(ticket),
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ticket image
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: typeColor.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: TravelImages.buildImageBackground(
                                  imageUrl: ticket.image ?? TravelImages.getTourImage(ticket.hashCode),
                                  opacity: 0.3,
                                  cacheWidth: 300,
                                  child: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
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
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.categoryBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.location_on, size: 14, color: AppTheme.categoryBlue),
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
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          typeColor.withOpacity(0.15),
                                          typeColor.withOpacity(0.08),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: typeColor.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      ticket.type,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: typeColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
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
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: AppTheme.sunsetGradient),
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.categoryOrange.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.book_online, color: Colors.white, size: 16),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  'Book',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
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
      ),
    );
  }
}

