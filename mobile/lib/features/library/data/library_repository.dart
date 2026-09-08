import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';

class LibraryRepository {
  final ApiClient _client;

  LibraryRepository(this._client);

  Future<List<Map<String, dynamic>>> getUserLibrary(String tab) async {
    final res = await _client.get(ApiEndpoints.library, queryParameters: {'tab': tab});
    return List<Map<String, dynamic>>.from(res);
  }
}
