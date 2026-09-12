import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/comment_model.dart';

class CommentsRepository {
  final ApiClient _client;

  CommentsRepository(this._client);

  Future<List<CommentModel>> getCommentsByChapter(String chapterId) async {
    final res = await _client.get('${ApiEndpoints.chapterComments}/$chapterId');
    final List<dynamic> items;
    if (res is Map<String, dynamic> && res['items'] is List<dynamic>) {
      items = res['items'] as List<dynamic>;
    } else if (res is List) {
      items = res;
    } else {
      items = [];
    }
    return items
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CommentModel> createComment({
    required String chapterId,
    required String content,
    String? quoteText,
    int? paragraphIndex,
    bool isSpoiler = false,
  }) async {
    final res = await _client.post(ApiEndpoints.createComment, data: {
      'chapterId': chapterId,
      'content': content,
      'quoteText': quoteText,
      'paragraphIndex': paragraphIndex,
      'isSpoiler': isSpoiler,
    });
    return CommentModel.fromJson(res);
  }

  Future<bool> toggleLikeComment(String commentId) async {
    final res =
        await _client.post('${ApiEndpoints.likeComment}/$commentId/like');
    return res['isLiked'] ?? false;
  }
}
