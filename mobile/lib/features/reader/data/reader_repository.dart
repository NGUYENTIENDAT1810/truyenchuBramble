import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/offline_chapter_storage.dart';

class ReaderRepository {
  final ApiClient _client;

  ReaderRepository(this._client);

  Future<Map<String, dynamic>> getChapterContent(String chapterId) async {
    // 1. Try local offline cache first if present
    final cached = OfflineChapterStorage.getChapter(chapterId);
    if (cached != null) {
      return cached;
    }

    // 2. Fetch from backend API
    try {
      final res = await _client.get('${ApiEndpoints.chapterContent}/$chapterId');
      return Map<String, dynamic>.from(res);
    } catch (e) {
      // If network fails, re-check offline storage
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> unlockChapter(String chapterId) async {
    final res = await _client.post('${ApiEndpoints.unlockChapter}/$chapterId/unlock');
    return Map<String, dynamic>.from(res);
  }

  Future<void> syncProgress({
    required String bookId,
    required String chapterId,
    required double scrollOffset,
    required double percentage,
    int deltaSeconds = 0,
  }) async {
    try {
      await _client.post(ApiEndpoints.syncProgress, data: {
        'bookId': bookId,
        'chapterId': chapterId,
        'scrollOffset': scrollOffset,
        'percentage': percentage,
        'deltaSeconds': deltaSeconds,
      });
    } catch (_) {}
  }

  Future<void> downloadChapter(String chapterId) async {
    final res = await _client.get('${ApiEndpoints.chapterContent}/$chapterId');
    await OfflineChapterStorage.saveChapter(chapterId, Map<String, dynamic>.from(res));
  }
}
