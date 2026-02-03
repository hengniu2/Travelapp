class Ticket {
  final String id;
  final String name;
  final String? image;
  final String location;
  final double price;
  final String type;
  final String? description;
  final DateTime? validFrom;
  final DateTime? validTo;

  Ticket({
    required this.id,
    required this.name,
    this.image,
    required this.location,
    required this.price,
    required this.type,
    this.description,
    this.validFrom,
    this.validTo,
  });
}



