import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/comments_repository.dart';
import '../../domain/comment_model.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object?> get props => [];
}

class CommentsInitial extends CommentsState {
  const CommentsInitial();
}

class CommentsLoading extends CommentsState {
  const CommentsLoading();
}

class CommentsLoaded extends CommentsState {
  final List<CommentModel> comments;

  const CommentsLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class CommentsFailure extends CommentsState {
  final String message;

  const CommentsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentsCubit extends Cubit<CommentsState> {
  final CommentsRepository _commentsRepository;

  CommentsCubit({required CommentsRepository commentsRepository})
      : _commentsRepository = commentsRepository,
        super(const CommentsInitial());

  Future<void> loadComments(String chapterId) async {
    emit(const CommentsLoading());
    try {
      final comments = await _commentsRepository.getCommentsByChapter(chapterId);
      emit(CommentsLoaded(comments));
    } catch (e) {
      emit(CommentsFailure(e.toString()));
    }
  }

  Future<void> addComment({
    required String chapterId,
    required String content,
    String? quoteText,
    int? paragraphIndex,
    bool isSpoiler = false,
  }) async {
    try {
      final newComment = await _commentsRepository.createComment(
        chapterId: chapterId,
        content: content,
        quoteText: quoteText,
        paragraphIndex: paragraphIndex,
        isSpoiler: isSpoiler,
      );
      final current = state;
      if (current is CommentsLoaded) {
        emit(CommentsLoaded([newComment, ...current.comments]));
      } else {
        emit(CommentsLoaded([newComment]));
      }
    } catch (_) {}
  }

  Future<void> toggleLike(String commentId) async {
    final current = state;
    if (current is CommentsLoaded) {
      final updated = current.comments.map((c) {
        if (c.id == commentId) {
          final nextLiked = !c.isLiked;
          return c.copyWith(
            isLiked: nextLiked,
            likes: nextLiked ? c.likes + 1 : (c.likes > 0 ? c.likes - 1 : 0),
          );
        }
        return c;
      }).toList();
      emit(CommentsLoaded(updated));
      try {
        await _commentsRepository.toggleLikeComment(commentId);
      } catch (_) {}
    }
  }
}
