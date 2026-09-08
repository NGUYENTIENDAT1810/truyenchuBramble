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
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? (json['authorName'] ?? ''),
      authorId: json['authorId'],
      authorInitial: json['authorInitial'],
      authorAvatarBg: json['authorAvatarBg'],
      authorBio: json['authorBio'],
      authorNote: json['authorNote'],
      blurb: json['blurb'] ?? '',
      coverColor: json['coverColor'] ?? '#56633f',
      coverInkColor: json['coverInkColor'] ?? '#f0fae1',
      coverImageUrl: json['coverImageUrl'],
      tag: json['tag'] ?? (json['primaryTag'] ?? 'Slow fantasy'),
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.7,
      readersCount: json['readersCount'] ?? 14200,
      totalChapters: json['totalChapters'] ?? (json['chapters'] ?? 0),
      badge: json['badge'],
      status: json['status'],
      isSaved: json['isSaved'] ?? false,
      readingProgress: json['readingProgress'] as Map<String, dynamic>?,
    );
  }
}
