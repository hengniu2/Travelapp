class Tour {
  final String id;
  final String title;
  /// Chinese (or other locale) title when available; use when locale is zh.
  final String? titleZh;
  final String? image;
  final String description;
  /// Chinese (or other locale) description when available; use when locale is zh.
  final String? _descriptionZh;
  String? get descriptionZh => _descriptionZh;
  final List<String> route;
  final String routeType;
  final double price;
  final int duration;
  final double rating;
  final int reviewCount;
  final int maxParticipants;
  final DateTime startDate;
  final bool isTrending;
  final Map<String, dynamic>? packageDetails;

  Tour({
    required this.id,
    required this.title,
    this.titleZh,
    this.image,
    required this.description,
    String? descriptionZh,
    required this.route,
    required this.routeType,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviewCount,
    required this.maxParticipants,
    required this.startDate,
    this.isTrending = false,
    this.packageDetails,
  }) : _descriptionZh = descriptionZh;
}



