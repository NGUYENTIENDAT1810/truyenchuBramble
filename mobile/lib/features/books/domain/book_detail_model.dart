class BookModel {
  final String id;
  final String title;
  final String author;
  final String? authorId;
  final String? authorInitial;
  final String? authorAvatarBg;
  final String? authorBio;
  final String? authorNote;
  final String blurb;
  final String coverColor;
  final String coverInkColor;
  final String? coverImageUrl;
  final String tag;
  final double rating;
  final int readersCount;
  final int totalChapters;
  final String? badge;
  final String? status;
  final bool isSaved;
  final Map<String, dynamic>? readingProgress;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.authorId,
    this.authorInitial,
    this.authorAvatarBg,
    this.authorBio,
    this.authorNote,
    this.blurb = '',
    this.coverColor = '#56633f',
    this.coverInkColor = '#f0fae1',
    this.coverImageUrl,
    this.tag = 'Slow fantasy',
    this.rating = 4.7,
    this.readersCount = 14200,
    this.totalChapters = 0,
    this.badge,
    this.status,
    this.isSaved = false,
    this.readingProgress,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final authorValue = json['author'];
    final author = authorValue is Map<String, dynamic>
        ? (authorValue['name'] ?? authorValue['displayName'] ?? '').toString()
        : (authorValue ?? json['authorName'] ?? '').toString();
    final authorMap = authorValue is Map<String, dynamic> ? authorValue : null;

    return BookModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      author: author,
      authorId: (json['authorId'] ?? authorMap?['id'])?.toString(),
      authorInitial: (json['authorInitial'] ?? authorMap?['initial'])?.toString(),
      authorAvatarBg: (json['authorAvatarBg'] ?? authorMap?['avatarUrl'])?.toString(),
      authorBio: (json['authorBio'] ?? authorMap?['bio'])?.toString(),
      authorNote: (json['authorNote'] ?? authorMap?['note'])?.toString(),
      blurb: (json['blurb'] ?? json['description'] ?? '').toString(),
      coverColor: (json['coverColor'] ?? '#56633f').toString(),
      coverInkColor: (json['coverInkColor'] ?? '#f0fae1').toString(),
      coverImageUrl: (json['coverImageUrl'] ?? json['coverUrl'])?.toString(),
      tag: (json['tag'] ?? json['primaryTag'] ?? 'Slow fantasy').toString(),
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.7,
      readersCount: (json['readersCount'] ?? json['viewsCount'] ?? 14200) is num
          ? ((json['readersCount'] ?? json['viewsCount'] ?? 14200) as num).toInt()
          : 14200,
      totalChapters: (json['totalChapters'] ?? json['chapters'] ?? 0) is num
          ? ((json['totalChapters'] ?? json['chapters'] ?? 0) as num).toInt()
          : 0,
      badge: json['badge']?.toString(),
      status: json['status']?.toString(),
      isSaved: json['isSaved'] ?? false,
      readingProgress: json['readingProgress'] as Map<String, dynamic>?,
    );
  }
}
