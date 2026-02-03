class Insurance {
  final String id;
  final String name;
  final String type;
  final double price;
  final String coverage;
  final int duration;
  final String? description;
  final List<String> benefits;

  Insurance({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.coverage,
    required this.duration,
    this.description,
    required this.benefits,
  });
}



