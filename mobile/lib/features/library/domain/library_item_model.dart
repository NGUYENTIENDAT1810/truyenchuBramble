import '../../books/domain/book_detail_model.dart';

class LibraryItemModel {
  final String id;
  final String bookId;
  final BookModel? book;
  final String status;
  final int progressPercent;
  final String? lastReadChapterId;
  final int? lastReadChapterNumber;
  final String? lastReadChapterTitle;
  final String? lastReadAt;
  final String? createdAt;

  const LibraryItemModel({
    required this.id,
    required this.bookId,
    this.book,
    required this.status,
    this.progressPercent = 0,
    this.lastReadChapterId,
    this.lastReadChapterNumber,
    this.lastReadChapterTitle,
    this.lastReadAt,
    this.createdAt,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'bookId':
        return bookId;
      case 'book':
        return book?.toJson();
      case 'title':
        return book?.title;
      case 'author':
        return book?.author;
      case 'coverImageUrl':
      case 'coverUrl':
        return book?.coverImageUrl;
      case 'coverColor':
        return book?.coverColor;
      case 'coverInkColor':
        return book?.coverInkColor;
      case 'status':
        return status;
      case 'progressPercent':
        return progressPercent;
      case 'totalChapters':
        return book?.totalChapters;
      case 'tag':
        return book?.tag;
      case 'lastReadChapterId':
        return lastReadChapterId;
      case 'lastReadChapterNumber':
        return lastReadChapterNumber;
      case 'lastReadChapterTitle':
        return lastReadChapterTitle;
      case 'lastReadAt':
        return lastReadAt;
      case 'createdAt':
        return createdAt;
      default:
        return null;
    }
  }

  factory LibraryItemModel.fromJson(Map<String, dynamic> json) {
    return LibraryItemModel(
      id: (json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      book: json['book'] is Map<String, dynamic>
          ? BookModel.fromJson(json['book'] as Map<String, dynamic>)
          : (json.containsKey('title') ? BookModel.fromJson(json) : null),
      status: (json['status'] ?? 'SAVED').toString(),
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      lastReadChapterId: json['lastReadChapterId']?.toString(),
      lastReadChapterNumber: (json['lastReadChapterNumber'] as num?)?.toInt(),
      lastReadChapterTitle: json['lastReadChapterTitle']?.toString(),
      lastReadAt: json['lastReadAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'book': book?.toJson(),
      'status': status,
      'progressPercent': progressPercent,
      'lastReadChapterId': lastReadChapterId,
      'lastReadChapterNumber': lastReadChapterNumber,
      'lastReadChapterTitle': lastReadChapterTitle,
      'lastReadAt': lastReadAt,
      'createdAt': createdAt,
    };
  }
}
