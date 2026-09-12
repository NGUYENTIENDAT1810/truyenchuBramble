import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/stats_model.dart';

class StatsRepository {
  final ApiClient _client;

  StatsRepository(this._client);

  Future<StatsResponseModel> getUserStats() async {
    final res = await _client.get(ApiEndpoints.stats);
    return StatsResponseModel.fromJson(Map<String, dynamic>.from(res));
  }
}
