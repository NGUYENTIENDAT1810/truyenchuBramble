import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../books/domain/book_detail_model.dart';

class DiscoverRepository {
  final ApiClient _client;

  DiscoverRepository(this._client);

  Future<Map<String, dynamic>> getDiscoverData() async {
    final res = await _client.get(ApiEndpoints.discover);
    return res;
  }

  Future<List<BookModel>> searchBooks({String? query, String? tag}) async {
    final res = await _client.get(ApiEndpoints.books, queryParameters: {
      if (query != null && query.isNotEmpty) 'query': query,
      if (tag != null && tag != 'All') 'tag': tag,
    });
    final items = res['items'] as List? ?? [];
    return items.map((e) => BookModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
