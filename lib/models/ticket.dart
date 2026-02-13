class Ticket {
  final String id;
  final String name;
  /// Chinese (or other locale) name when available; use when locale is zh.
  final String? nameZh;
  final String? image;
  final String location;
  /// Chinese (or other locale) location when available; use when locale is zh.
  final String? locationZh;
  final double price;
  final String type;
  /// Chinese (or other locale) type label when available; use when locale is zh.
  final String? typeZh;
  final String? description;
  final DateTime? validFrom;
  final DateTime? validTo;

  Ticket({
    required this.id,
    required this.name,
    this.nameZh,
    this.image,
    required this.location,
    this.locationZh,
    required this.price,
    required this.type,
    this.typeZh,
    this.description,
    this.validFrom,
    this.validTo,
  });
}



