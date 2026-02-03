class Companion {
  final String id;
  final String name;
  final String? avatar;
  final List<String> destinations;
  final List<String> interests;
  final List<String> skills;
  final double rating;
  final int reviewCount;
  final String? bio;
  final double pricePerDay;
  final bool isAvailable;
  final List<String> languages;

  Companion({
    required this.id,
    required this.name,
    this.avatar,
    required this.destinations,
    required this.interests,
    required this.skills,
    required this.rating,
    required this.reviewCount,
    this.bio,
    required this.pricePerDay,
    required this.isAvailable,
    required this.languages,
  });
}



