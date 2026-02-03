class TravelContent {
  final String id;
  final String title;
  final String? image;
  final String content;
  final String type;
  final String? author;
  final DateTime publishDate;
  final List<String>? tags;
  final int views;
  final int likes;

  TravelContent({
    required this.id,
    required this.title,
    this.image,
    required this.content,
    required this.type,
    this.author,
    required this.publishDate,
    this.tags,
    this.views = 0,
    this.likes = 0,
  });
}



