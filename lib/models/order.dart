class Order {
  final String id;
  final String type;
  final String itemId;
  final String itemName;
  final String? itemImage;
  final double amount;
  final DateTime orderDate;
  final String status;
  final Map<String, dynamic>? details;

  Order({
    required this.id,
    required this.type,
    required this.itemId,
    required this.itemName,
    this.itemImage,
    required this.amount,
    required this.orderDate,
    required this.status,
    this.details,
  });
}



