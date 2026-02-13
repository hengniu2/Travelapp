/// 旅行论坛/文章下的评论
class ContentComment {
  final String id;
  final String contentId;
  final String authorName;
  final String? authorNameZh;
  final String body;
  final String? bodyZh;
  final DateTime date;

  ContentComment({
    required this.id,
    required this.contentId,
    required this.authorName,
    this.authorNameZh,
    required this.body,
    this.bodyZh,
    required this.date,
  });
}
