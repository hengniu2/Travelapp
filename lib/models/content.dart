class TravelContent {
  final String id;
  final String title;
  final String? titleZh;
  final String? image;
  final String content;
  final String? contentZh;
  final String type;
  final String? author;
  final String? authorZh;
  final DateTime publishDate;
  final List<String>? tags;
  final int views;
  final int likes;

  TravelContent({
    required this.id,
    required this.title,
    this.titleZh,
    this.image,
    required this.content,
    this.contentZh,
    required this.type,
    this.author,
    this.authorZh,
    required this.publishDate,
    this.tags,
    this.views = 0,
    this.likes = 0,
  });
}



