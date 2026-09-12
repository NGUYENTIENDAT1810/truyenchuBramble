import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/book_detail_model.dart';
import '../domain/chapter_model.dart';

class BookRepository {
  final ApiClient _client;

  BookRepository(this._client);

  Future<BookModel> getBookById(String id) async {
    final res = await _client.get('${ApiEndpoints.books}/$id');
    return BookModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<BookDetailModel> getBookDetail(String id) async {
    final res = await _client.get('${ApiEndpoints.books}/$id');
    return BookDetailModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<List<ChapterModel>> getChaptersByBookId(String bookId, {String sort = 'asc'}) async {
    final res = await _client.get('${ApiEndpoints.chaptersByBook}/$bookId', queryParameters: {'sort': sort});
    final rawItems = res is List ? res : (res is Map && res['items'] is List ? res['items'] as List : []);
    return rawItems
        .whereType<Map<String, dynamic>>()
        .map((e) => ChapterModel.fromJson(e))
        .toList();
  }

  Future<AuthorModel> getAuthorById(String authorId) async {
    final res = await _client.get('${ApiEndpoints.author}/$authorId');
    return AuthorModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<bool> toggleFollowAuthor(String authorId) async {
    final res = await _client.post('${ApiEndpoints.author}/$authorId/follow');
    return res['isFollowed'] ?? false;
  }

  Future<bool> toggleSaveBook(String bookId) async {
    final res = await _client.post(ApiEndpoints.toggleSave, data: {'bookId': bookId});
    return res['isSaved'] ?? false;
  }

  Future<BookModel> createBook({
    required String title,
    String? description,
    String status = 'ONGOING',
  }) async {
    final res = await _client.post(ApiEndpoints.adminBooks, data: {
      'title': title,
      'description': description,
      'status': status,
    });
    return BookModel.fromJson(Map<String, dynamic>.from(res));
  }
}
