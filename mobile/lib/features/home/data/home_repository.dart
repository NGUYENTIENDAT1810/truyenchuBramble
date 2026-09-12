import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../books/domain/book_detail_model.dart';
import '../../reader/domain/chapter_detail_model.dart';
import '../../stats/domain/stats_model.dart';

class HomeDataModel {
  final ActiveReadingModel? activeReading;
  final List<BookModel> newChapters;
  final List<BookModel> recommendations;
  final int streak;

  const HomeDataModel({
    this.activeReading,
    this.newChapters = const [],
    this.recommendations = const [],
    this.streak = 0,
  });
}

class HomeRepository {
  final ApiClient _client;

  HomeRepository(this._client);

  Future<Map<String, dynamic>> getHomeData() async {
    final results = await Future.wait([
      _client.get(ApiEndpoints.activeReading),
      _client.get(ApiEndpoints.discover),
      _client.get(ApiEndpoints.stats),
    ]);

    final rawActiveReading = results[0] as Map<String, dynamic>?;
    final activeReading = rawActiveReading != null && rawActiveReading.isNotEmpty
        ? ActiveReadingModel.fromJson(rawActiveReading)
        : null;

    final discover = results[1] is Map<String, dynamic> ? results[1] as Map<String, dynamic> : <String, dynamic>{};
    final rawStats = results[2] as Map<String, dynamic>?;
    final stats = rawStats != null ? StatsResponseModel.fromJson(rawStats) : null;

    final trendingList = (discover['trending'] as List? ??
            discover['featured'] as List? ??
            discover['newReleases'] as List? ??
            [])
        .whereType<Map<String, dynamic>>()
        .map((e) => BookModel.fromJson(e))
        .toList();

    final recommendedList = (discover['recommended'] as List? ??
            discover['featured'] as List? ??
            trendingList)
        .whereType<Map<String, dynamic>>()
        .map((e) => BookModel.fromJson(e))
        .toList();

    return {
      'activeReading': activeReading,
      'newChapters': trendingList,
      'recommendations': recommendedList,
      'streak': stats?.currentStreakDays ?? 12,
    };
  }
}
