class Insurance {
  final String id;
  final String name;
  /// Localized name when locale is zh.
  final String? nameZh;
  final String type;
  /// Localized type when locale is zh.
  final String? typeZh;
  final double price;
  final String coverage;
  /// Localized coverage when locale is zh.
  final String? coverageZh;
  final int duration;
  final String? description;
  final List<String> benefits;
  /// Localized benefits when locale is zh (same order as benefits).
  final List<String>? benefitsZh;

  Insurance({
    required this.id,
    required this.name,
    this.nameZh,
    required this.type,
    this.typeZh,
    required this.price,
    required this.coverage,
    this.coverageZh,
    required this.duration,
    this.description,
    required this.benefits,
    this.benefitsZh,
  });
}



