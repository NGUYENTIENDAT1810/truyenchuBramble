import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../books/domain/book_detail_model.dart';
import '../domain/discover_response_model.dart';

class DiscoverRepository {
  final ApiClient _client;

  DiscoverRepository(this._client);

  Future<DiscoverResponseModel> getDiscoverData() async {
    final res = await _client.get(ApiEndpoints.discover);
    return DiscoverResponseModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<List<BookModel>> searchBooks({String? query, String? tag}) async {
    final res = await _client.get(ApiEndpoints.books, queryParameters: {
      if (query != null && query.isNotEmpty) 'query': query,
      if (tag != null && tag != 'All') 'tag': tag,
    });
    final items = res['items'] as List? ?? [];
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => BookModel.fromJson(e))
        .toList();
  }
}
