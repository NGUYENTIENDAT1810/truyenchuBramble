class CommentModel {
  final String id;
  final String chapterId;
  final String userId;
  final String name;
  final String? avatarUrl;
  final String initial;
  final String color;
  final String time;
  final String quote;
  final int? paragraphIndex;
  final String text;
  final bool isSpoiler;
  final int likes;
  final bool isLiked;
  final String? parentId;
  final List<CommentModel> replies;

  const CommentModel({
    required this.id,
    required this.chapterId,
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.initial,
    this.color = '#b2622d',
    required this.time,
    this.quote = '',
    this.paragraphIndex,
    required this.text,
    this.isSpoiler = false,
    this.likes = 0,
    this.isLiked = false,
    this.parentId,
    this.replies = const [],
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'chapterId':
        return chapterId;
      case 'userId':
        return userId;
      case 'userName':
      case 'name':
        return name;
      case 'userAvatarUrl':
      case 'avatarUrl':
        return avatarUrl;
      case 'initial':
        return initial;
      case 'color':
        return color;
      case 'time':
      case 'createdAt':
        return time;
      case 'quote':
      case 'quoteText':
        return quote;
      case 'paragraphIndex':
        return paragraphIndex;
      case 'content':
      case 'text':
        return text;
      case 'isSpoiler':
        return isSpoiler;
      case 'likes':
      case 'likesCount':
        return likes;
      case 'isLiked':
        return isLiked;
      case 'parentId':
        return parentId;
      case 'replies':
        return replies;
      default:
        return null;
    }
  }

  CommentModel copyWith({
    String? id,
    String? chapterId,
    String? userId,
    String? name,
    String? avatarUrl,
    String? initial,
    String? color,
    String? time,
    String? quote,
    int? paragraphIndex,
    String? text,
    bool? isSpoiler,
    int? likes,
    bool? isLiked,
    String? parentId,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      initial: initial ?? this.initial,
      color: color ?? this.color,
      time: time ?? this.time,
      quote: quote ?? this.quote,
      paragraphIndex: paragraphIndex ?? this.paragraphIndex,
      text: text ?? this.text,
      isSpoiler: isSpoiler ?? this.isSpoiler,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      parentId: parentId ?? this.parentId,
      replies: replies ?? this.replies,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final name = (json['userName'] ?? json['name'] ?? 'Reader').toString();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'R';
    final text = (json['content'] ?? json['text'] ?? '').toString();
    final likes = (json['likesCount'] as num?)?.toInt() ?? (json['likes'] as num?)?.toInt() ?? 0;
    final isLiked = json['isLiked'] ?? false;

    return CommentModel(
      id: (json['id'] ?? '').toString(),
      chapterId: (json['chapterId'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      name: name,
      avatarUrl: json['userAvatarUrl']?.toString() ?? json['avatarUrl']?.toString(),
      initial: json['initial']?.toString() ?? initial,
      color: json['color'] ?? '#b2622d',
      time: json['time'] ?? 'Just now',
      quote: json['quote'] ?? '',
      paragraphIndex: (json['paragraphIndex'] as num?)?.toInt(),
      text: text,
      isSpoiler: json['isSpoiler'] ?? false,
      likes: likes,
      isLiked: isLiked,
      parentId: json['parentId']?.toString(),
      replies: (json['replies'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((r) => CommentModel.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'userId': userId,
      'userName': name,
      'name': name,
      'userAvatarUrl': avatarUrl,
      'avatarUrl': avatarUrl,
      'initial': initial,
      'color': color,
      'time': time,
      'quote': quote,
      'paragraphIndex': paragraphIndex,
      'content': text,
      'text': text,
      'isSpoiler': isSpoiler,
      'likesCount': likes,
      'likes': likes,
      'isLiked': isLiked,
      'parentId': parentId,
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }
}
