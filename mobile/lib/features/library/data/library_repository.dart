import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/library_item_model.dart';

class LibraryRepository {
  final ApiClient _client;

  LibraryRepository(this._client);

  Future<List<LibraryItemModel>> getUserLibrary(String tab) async {
    final res = await _client.get(ApiEndpoints.library, queryParameters: {'tab': tab});
    final rawItems = res is List ? res : (res is Map && res['items'] is List ? res['items'] as List : []);
    return rawItems
        .whereType<Map<String, dynamic>>()
        .map((e) => LibraryItemModel.fromJson(e))
        .toList();
  }
}
