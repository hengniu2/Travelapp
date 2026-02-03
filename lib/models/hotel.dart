class Hotel {
  final String id;
  final String name;
  final String? image;
  final String location;
  final double pricePerNight;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final String? description;

  Hotel({
    required this.id,
    required this.name,
    this.image,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    this.description,
  });
}



