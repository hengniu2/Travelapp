class Hotel {
  final String id;
  final String name;
  /// Localized name when locale is zh.
  final String? nameZh;
  final String? image;
  final String location;
  /// Localized location when locale is zh.
  final String? locationZh;
  final double pricePerNight;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  /// Localized amenities when locale is zh (same order as amenities).
  final List<String>? amenitiesZh;
  final String? description;

  Hotel({
    required this.id,
    required this.name,
    this.nameZh,
    this.image,
    required this.location,
    this.locationZh,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    this.amenitiesZh,
    this.description,
  });
}



