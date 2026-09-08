import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/comments_repository.dart';
import '../domain/comment_model.dart';

final commentsRepositoryProvider = Provider<CommentsRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return CommentsRepository(client);
});

final chapterCommentsProvider =
    FutureProvider.autoDispose.family<List<CommentModel>, String>((ref, chapterId) async {
  final repo = ref.watch(commentsRepositoryProvider);
  return repo.getCommentsByChapter(chapterId);
});
