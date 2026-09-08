import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';

class StatsRepository {
  final ApiClient _client;

  StatsRepository(this._client);

  Future<Map<String, dynamic>> getUserStats() async {
    final res = await _client.get(ApiEndpoints.stats);
    return Map<String, dynamic>.from(res);
  }
}
