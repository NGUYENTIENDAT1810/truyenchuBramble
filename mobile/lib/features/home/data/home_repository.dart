import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../books/domain/book_detail_model.dart';

class HomeRepository {
  final ApiClient _client;

  HomeRepository(this._client);

  Future<Map<String, dynamic>> getHomeData() async {
    final results = await Future.wait([
      _client.get(ApiEndpoints.activeReading),
      _client.get(ApiEndpoints.discover),
      _client.get(ApiEndpoints.stats),
    ]);

    final activeReading = results[0] as Map<String, dynamic>?;
    final discover = results[1] as Map<String, dynamic>;
    final stats = results[2] as Map<String, dynamic>?;

    final trendingList = (discover['trending'] as List? ?? [])
        .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final recommendedList = (discover['recommended'] as List? ?? [])
        .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return {
      'activeReading': activeReading,
      'newChapters': trendingList,
      'recommendations': recommendedList,
      'streak': stats?['streakDays'] ?? 12,
    };
  }
}
