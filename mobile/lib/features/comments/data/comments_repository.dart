import '../../../core/network/api_client.dart';
import '../domain/comment_model.dart';

class CommentsRepository {
  final ApiClient _client;

  CommentsRepository(this._client);

  Future<List<CommentModel>> getCommentsByChapter(String chapterId) async {
    final res = await _client.get('/chapters/$chapterId/comments');
    final List<dynamic> items;
    if (res is Map<String, dynamic> && res['items'] is List<dynamic>) {
      items = res['items'] as List<dynamic>;
    } else if (res is List) {
      items = res;
    } else {
      items = [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map((e) => CommentModel.fromJson(e))
        .toList();
  }

  Future<CommentModel> createComment({
    required String chapterId,
    required String content,
    String? quoteText,
    int? paragraphIndex,
    bool isSpoiler = false,
  }) async {
    final res = await _client.post(
      '/chapters/$chapterId/comments',
      data: {
        'content': content,
        'paragraphIndex': paragraphIndex,
      },
    );
    return CommentModel.fromJson(res);
  }

  Future<bool> toggleLikeComment(String commentId) async {
    final res = await _client.post('/comments/$commentId/like');
    if (res is bool) return res;
    if (res is Map<String, dynamic>) {
      return res['isLiked'] ?? res['data'] ?? false;
    }
    return false;
  }
}
