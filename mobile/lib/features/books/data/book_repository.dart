import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/book_detail_model.dart';

class BookRepository {
  final ApiClient _client;

  BookRepository(this._client);

  Future<BookModel> getBookById(String id) async {
    final res = await _client.get('${ApiEndpoints.books}/$id');
    return BookModel.fromJson(res);
  }

  Future<List<Map<String, dynamic>>> getChaptersByBookId(String bookId, {String sort = 'asc'}) async {
    final res = await _client.get('${ApiEndpoints.chaptersByBook}/$bookId', queryParameters: {'sort': sort});
    return List<Map<String, dynamic>>.from(res);
  }

  Future<Map<String, dynamic>> getAuthorById(String authorId) async {
    final res = await _client.get('${ApiEndpoints.author}/$authorId');
    return Map<String, dynamic>.from(res);
  }

  Future<bool> toggleFollowAuthor(String authorId) async {
    final res = await _client.post('${ApiEndpoints.author}/$authorId/follow');
    return res['isFollowed'] ?? false;
  }

  Future<bool> toggleSaveBook(String bookId) async {
    final res = await _client.post(ApiEndpoints.toggleSave, data: {'bookId': bookId});
    return res['isSaved'] ?? false;
  }
}
