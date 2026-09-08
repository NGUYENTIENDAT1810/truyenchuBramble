class CommentModel {
  final String id;
  final String chapterId;
  final String userId;
  final String name;
  final String initial;
  final String color;
  final String time;
  final String quote;
  final int? paragraphIndex;
  final String text;
  final bool isSpoiler;
  final int likes;
  final bool isLiked;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.chapterId,
    required this.userId,
    required this.name,
    required this.initial,
    this.color = '#b2622d',
    required this.time,
    this.quote = '',
    this.paragraphIndex,
    required this.text,
    this.isSpoiler = false,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      chapterId: json['chapterId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? 'Reader',
      initial: json['initial'] ?? 'R',
      color: json['color'] ?? '#b2622d',
      time: json['time'] ?? '1h',
      quote: json['quote'] ?? '',
      paragraphIndex: json['paragraphIndex'],
      text: json['text'] ?? '',
      isSpoiler: json['isSpoiler'] ?? false,
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      replies: (json['replies'] as List? ?? [])
          .map((r) => CommentModel.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}
