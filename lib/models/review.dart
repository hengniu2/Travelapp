class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String itemId;
  final String itemType;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String>? images;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.itemId,
    required this.itemType,
    required this.rating,
    required this.comment,
    required this.date,
    this.images,
  });
}



