class ChapterModel {
  final String id;
  final String bookId;
  final int chapterNumber;
  final String title;
  final int wordCount;
  final bool isFree;
  final int coinCost;
  final bool isUnlocked;
  final int commentsCount;
  final String? createdAt;

  const ChapterModel({
    required this.id,
    required this.bookId,
    required this.chapterNumber,
    required this.title,
    this.wordCount = 0,
    this.isFree = true,
    this.coinCost = 0,
    this.isUnlocked = true,
    this.commentsCount = 0,
    this.createdAt,
  });

  bool get isLocked => !isFree && !isUnlocked;

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'bookId':
        return bookId;
      case 'chapterNumber':
        return chapterNumber;
      case 'title':
        return title;
      case 'wordCount':
        return wordCount;
      case 'isFree':
        return isFree;
      case 'coinCost':
      case 'coinPrice':
        return coinCost;
      case 'isUnlocked':
        return isUnlocked;
      case 'isLocked':
        return isLocked;
      case 'commentsCount':
        return commentsCount;
      case 'createdAt':
        return createdAt;
      default:
        return null;
    }
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: (json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      chapterNumber: (json['chapterNumber'] as num?)?.toInt() ?? 1,
      title: (json['title'] ?? '').toString(),
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
      isFree: json['isFree'] ?? true,
      coinCost: (json['coinCost'] as num?)?.toInt() ?? (json['coinPrice'] as num?)?.toInt() ?? 0,
      isUnlocked: json['isUnlocked'] ?? true,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'title': title,
      'wordCount': wordCount,
      'isFree': isFree,
      'coinCost': coinCost,
      'coinPrice': coinCost,
      'isUnlocked': isUnlocked,
      'isLocked': isLocked,
      'commentsCount': commentsCount,
      'createdAt': createdAt,
    };
  }
}
