import '../../books/domain/book_detail_model.dart';
import '../../books/domain/chapter_model.dart';

class ChapterDetailModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final int chapterNumber;
  final String title;
  final String content;
  final int wordCount;
  final bool isFree;
  final int coinCost;
  final bool isUnlocked;
  final int commentsCount;
  final String? prevChapterId;
  final String? nextChapterId;
  final int? prevChapterNumber;
  final int? nextChapterNumber;

  const ChapterDetailModel({
    required this.id,
    required this.bookId,
    this.bookTitle = '',
    required this.chapterNumber,
    required this.title,
    required this.content,
    this.wordCount = 0,
    this.isFree = true,
    this.coinCost = 0,
    this.isUnlocked = true,
    this.commentsCount = 0,
    this.prevChapterId,
    this.nextChapterId,
    this.prevChapterNumber,
    this.nextChapterNumber,
  });

  bool get isLocked => !isFree && !isUnlocked;

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'bookId':
        return bookId;
      case 'bookTitle':
        return bookTitle;
      case 'chapterNumber':
        return chapterNumber;
      case 'title':
        return title;
      case 'content':
        return content;
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
      case 'prevChapterId':
        return prevChapterId;
      case 'nextChapterId':
        return nextChapterId;
      case 'prevChapterNumber':
        return prevChapterNumber;
      case 'nextChapterNumber':
        return nextChapterNumber;
      default:
        return null;
    }
  }

  factory ChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return ChapterDetailModel(
      id: (json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      bookTitle: (json['bookTitle'] ?? '').toString(),
      chapterNumber: (json['chapterNumber'] as num?)?.toInt() ?? 1,
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
      isFree: json['isFree'] ?? true,
      coinCost: (json['coinCost'] as num?)?.toInt() ?? (json['coinPrice'] as num?)?.toInt() ?? 0,
      isUnlocked: json['isUnlocked'] ?? true,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      prevChapterId: json['prevChapterId']?.toString(),
      nextChapterId: json['nextChapterId']?.toString(),
      prevChapterNumber: (json['prevChapterNumber'] as num?)?.toInt(),
      nextChapterNumber: (json['nextChapterNumber'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'chapterNumber': chapterNumber,
      'title': title,
      'content': content,
      'wordCount': wordCount,
      'isFree': isFree,
      'coinCost': coinCost,
      'coinPrice': coinCost,
      'isUnlocked': isUnlocked,
      'isLocked': isLocked,
      'commentsCount': commentsCount,
      'prevChapterId': prevChapterId,
      'nextChapterId': nextChapterId,
      'prevChapterNumber': prevChapterNumber,
      'nextChapterNumber': nextChapterNumber,
    };
  }
}

class UnlockResponseModel {
  final bool success;
  final String chapterId;
  final int coinsDeducted;
  final int remainingCoins;
  final String message;

  const UnlockResponseModel({
    this.success = true,
    required this.chapterId,
    this.coinsDeducted = 0,
    this.remainingCoins = 0,
    this.message = 'Chapter unlocked',
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'success':
        return success;
      case 'chapterId':
        return chapterId;
      case 'coinsDeducted':
        return coinsDeducted;
      case 'remainingCoins':
        return remainingCoins;
      case 'message':
        return message;
      default:
        return null;
    }
  }

  factory UnlockResponseModel.fromJson(Map<String, dynamic> json) {
    return UnlockResponseModel(
      success: json['success'] ?? true,
      chapterId: (json['chapterId'] ?? '').toString(),
      coinsDeducted: (json['coinsDeducted'] as num?)?.toInt() ?? 0,
      remainingCoins: (json['remainingCoins'] as num?)?.toInt() ?? 0,
      message: (json['message'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'chapterId': chapterId,
      'coinsDeducted': coinsDeducted,
      'remainingCoins': remainingCoins,
      'message': message,
    };
  }
}

class ActiveReadingModel {
  final String id;
  final String bookId;
  final BookModel? book;
  final String chapterId;
  final ChapterModel? chapter;
  final int chapterNumber;
  final String chapterTitle;
  final int progressPercent;
  final double scrollOffset;
  final int readingTimeSeconds;
  final String? lastReadAt;

  const ActiveReadingModel({
    required this.id,
    required this.bookId,
    this.book,
    required this.chapterId,
    this.chapter,
    this.chapterNumber = 1,
    this.chapterTitle = '',
    this.progressPercent = 0,
    this.scrollOffset = 0.0,
    this.readingTimeSeconds = 0,
    this.lastReadAt,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'bookId':
        return bookId;
      case 'book':
        return book?.toJson();
      case 'bookTitle':
      case 'title':
        return book?.title ?? '';
      case 'author':
        return book?.author ?? '';
      case 'coverUrl':
      case 'coverImageUrl':
        return book?.coverImageUrl;
      case 'coverColor':
        return book?.coverColor;
      case 'coverInkColor':
        return book?.coverInkColor;
      case 'chapterId':
        return chapterId;
      case 'chapter':
        return chapter?.toJson();
      case 'chapterNumber':
        return chapterNumber;
      case 'chapterTitle':
        return chapterTitle;
      case 'progressPercent':
        return progressPercent;
      case 'percentage':
        return progressPercent / 100.0;
      case 'pctText':
        return '$progressPercent% read';
      case 'scrollOffset':
        return scrollOffset;
      case 'readingTimeSeconds':
        return readingTimeSeconds;
      case 'lastReadAt':
        return lastReadAt;
      default:
        return null;
    }
  }

  factory ActiveReadingModel.fromJson(Map<String, dynamic> json) {
    return ActiveReadingModel(
      id: (json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      book: json['book'] is Map<String, dynamic> ? BookModel.fromJson(json['book']) : null,
      chapterId: (json['chapterId'] ?? '').toString(),
      chapter: json['chapter'] is Map<String, dynamic> ? ChapterModel.fromJson(json['chapter']) : null,
      chapterNumber: (json['chapterNumber'] as num?)?.toInt() ?? 1,
      chapterTitle: (json['chapterTitle'] ?? '').toString(),
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      scrollOffset: (json['scrollOffset'] as num?)?.toDouble() ?? 0.0,
      readingTimeSeconds: (json['readingTimeSeconds'] as num?)?.toInt() ?? 0,
      lastReadAt: json['lastReadAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'book': book?.toJson(),
      'chapterId': chapterId,
      'chapter': chapter?.toJson(),
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'progressPercent': progressPercent,
      'scrollOffset': scrollOffset,
      'readingTimeSeconds': readingTimeSeconds,
      'lastReadAt': lastReadAt,
    };
  }
}

class ProgressResponseModel {
  final String id;
  final String bookId;
  final String chapterId;
  final int progressPercent;
  final double scrollOffset;
  final int readingTimeSeconds;
  final String? lastReadAt;

  const ProgressResponseModel({
    required this.id,
    required this.bookId,
    required this.chapterId,
    this.progressPercent = 0,
    this.scrollOffset = 0.0,
    this.readingTimeSeconds = 0,
    this.lastReadAt,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'bookId':
        return bookId;
      case 'chapterId':
        return chapterId;
      case 'progressPercent':
        return progressPercent;
      case 'scrollOffset':
        return scrollOffset;
      case 'readingTimeSeconds':
        return readingTimeSeconds;
      case 'lastReadAt':
        return lastReadAt;
      default:
        return null;
    }
  }

  factory ProgressResponseModel.fromJson(Map<String, dynamic> json) {
    return ProgressResponseModel(
      id: (json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      chapterId: (json['chapterId'] ?? '').toString(),
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      scrollOffset: (json['scrollOffset'] as num?)?.toDouble() ?? 0.0,
      readingTimeSeconds: (json['readingTimeSeconds'] as num?)?.toInt() ?? 0,
      lastReadAt: json['lastReadAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'chapterId': chapterId,
      'progressPercent': progressPercent,
      'scrollOffset': scrollOffset,
      'readingTimeSeconds': readingTimeSeconds,
      'lastReadAt': lastReadAt,
    };
  }
}
