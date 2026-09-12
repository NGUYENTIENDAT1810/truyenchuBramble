import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/offline_chapter_storage.dart';
import '../domain/chapter_detail_model.dart';

class ReaderRepository {
  final ApiClient _client;

  ReaderRepository(this._client);

  Future<ChapterDetailModel> getChapterContent(String chapterId) async {
    // 1. Try local offline cache first if present
    final cached = OfflineChapterStorage.getChapter(chapterId);
    if (cached != null) {
      return ChapterDetailModel.fromJson(cached);
    }

    // 2. Fetch from backend API
    try {
      final res = await _client.get('${ApiEndpoints.chapterContent}/$chapterId');
      final map = Map<String, dynamic>.from(res);
      return ChapterDetailModel.fromJson(map);
    } catch (e) {
      // If network fails, re-check offline storage
      if (cached != null) return ChapterDetailModel.fromJson(cached);
      rethrow;
    }
  }

  Future<UnlockResponseModel> unlockChapter(String chapterId) async {
    final res = await _client.post('${ApiEndpoints.unlockChapter}/$chapterId/unlock');
    return UnlockResponseModel.fromJson(Map<String, dynamic>.from(res));
  }

  Future<void> syncProgress({
    required String bookId,
    required String chapterId,
    required double scrollOffset,
    required double percentage,
    int deltaSeconds = 0,
  }) async {
    try {
      await _client.post('${ApiEndpoints.syncProgress}/$bookId', data: {
        'chapterId': chapterId,
        'progressPercent': (percentage * 100).round(),
        'scrollOffset': scrollOffset.toDouble(),
        'readingTimeSeconds': deltaSeconds,
      });
    } catch (_) {}
  }

  Future<void> downloadChapter(String chapterId) async {
    final res = await _client.get('${ApiEndpoints.chapterContent}/$chapterId');
    await OfflineChapterStorage.saveChapter(chapterId, Map<String, dynamic>.from(res));
  }
}
