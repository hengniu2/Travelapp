class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final DateTime? joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.joinDate,
  });
}



