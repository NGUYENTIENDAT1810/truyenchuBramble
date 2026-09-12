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

  const CommentModel({
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

  CommentModel copyWith({
    String? id,
    String? chapterId,
    String? userId,
    String? name,
    String? initial,
    String? color,
    String? time,
    String? quote,
    int? paragraphIndex,
    String? text,
    bool? isSpoiler,
    int? likes,
    bool? isLiked,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      initial: initial ?? this.initial,
      color: color ?? this.color,
      time: time ?? this.time,
      quote: quote ?? this.quote,
      paragraphIndex: paragraphIndex ?? this.paragraphIndex,
      text: text ?? this.text,
      isSpoiler: isSpoiler ?? this.isSpoiler,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
    );
  }

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
