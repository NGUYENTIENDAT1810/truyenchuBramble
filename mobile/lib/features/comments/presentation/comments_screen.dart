import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../data/comments_repository.dart';
import '../domain/comment_model.dart';
import 'cubit/comments_cubit.dart';

class CommentsScreen extends StatelessWidget {
  final String chapterId;

  const CommentsScreen({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentsCubit(
        commentsRepository: context.read<CommentsRepository>(),
      )..loadComments(chapterId),
      child: _CommentsView(chapterId: chapterId),
    );
  }
}

class _CommentsView extends StatefulWidget {
  final String chapterId;

  const _CommentsView({required this.chapterId});

  @override
  State<_CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<_CommentsView> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    _commentController.clear();
    FocusScope.of(context).unfocus();

    context.read<CommentsCubit>().addComment(
          chapterId: widget.chapterId,
          content: text,
        );
  }

  void _toggleLike(CommentModel c) {
    context.read<CommentsCubit>().toggleLike(c.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: BrambleColors.creamBg,
                border: Border(
                  bottom: BorderSide(
                    color: BrambleColors.creamDivider.withOpacity(0.6),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: BrambleColors.creamSurface,
                        border: Border.all(
                          color: BrambleColors.creamBorder.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: BrambleColors.creamInk,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reader Notes & Comments',
                          style: BrambleTypography.titleLarge(
                            color: BrambleColors.creamInk,
                          ),
                        ),
                        Text(
                          'Community thoughts on this chapter',
                          style: BrambleTypography.caption(
                            color: BrambleColors.creamMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main List
            Expanded(
              child: BlocBuilder<CommentsCubit, CommentsState>(
                builder: (context, state) {
                  if (state is CommentsLoading || state is CommentsInitial) {
                    return const BrambleLoading(message: 'Loading reader notes...');
                  }

                  if (state is CommentsFailure) {
                    return BrambleErrorView(
                      message: state.message,
                      onRetry: () => context.read<CommentsCubit>().loadComments(widget.chapterId),
                    );
                  }

                  final comments = state is CommentsLoaded ? state.comments : <CommentModel>[];

                  if (comments.isEmpty) {
                    return const BrambleEmptyState(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'No notes yet',
                      subtitle: 'Start the conversation by sharing your thoughts below.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => Divider(
                      color: BrambleColors.creamDivider.withOpacity(0.4),
                      height: 24,
                    ),
                    itemBuilder: (context, index) {
                      final c = comments[index];

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: BrambleColors.creamSurface,
                              border: Border.all(
                                color: BrambleColors.creamBorder.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                c.initial,
                                style: BrambleTypography.titleMedium(
                                  color: BrambleColors.creamInk,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      c.name,
                                      style: BrambleTypography.bodyMedium(
                                        color: BrambleColors.creamInk,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      c.time,
                                      style: BrambleTypography.caption(
                                        color: BrambleColors.creamMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                if (c.quote.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: BrambleColors.creamSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: const Border(
                                        left: BorderSide(
                                          color: BrambleColors.primaryOrange,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '“${c.quote}”',
                                      style: BrambleTypography.caption(
                                        color: BrambleColors.creamSubdued,
                                      ).copyWith(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Text(
                                  c.text,
                                  style: BrambleTypography.bodyMedium(
                                    color: BrambleColors.creamInk,
                                  ).copyWith(height: 1.5),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _toggleLike(c),
                                      child: Container(
                                        height: 26,
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: c.isLiked
                                              ? BrambleColors.primaryOrange
                                              : BrambleColors.creamSurface,
                                          borderRadius: BorderRadius.circular(999),
                                          border: Border.all(
                                            color: c.isLiked
                                                ? BrambleColors.primaryOrange
                                                : BrambleColors.creamBorder.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.favorite_rounded,
                                              size: 13,
                                              color: c.isLiked
                                                  ? const Color(0xFFFFF2EB)
                                                  : BrambleColors.creamMuted,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${c.likes}',
                                              style: BrambleTypography.caption(
                                                color: c.isLiked
                                                    ? const Color(0xFFFFF2EB)
                                                    : BrambleColors.creamSubdued,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                10,
                16,
                MediaQuery.of(context).padding.bottom > 0
                    ? MediaQuery.of(context).padding.bottom + 6
                    : 14,
              ),
              decoration: BoxDecoration(
                color: BrambleColors.creamSurface,
                border: Border(
                  top: BorderSide(
                    color: BrambleColors.creamBorder.withOpacity(0.6),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamBg,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: BrambleColors.creamBorder.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: BrambleTypography.bodyMedium(
                          color: BrambleColors.creamInk,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a literary note or thought...',
                          hintStyle: BrambleTypography.bodyMedium(
                            color: BrambleColors.creamMuted,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _submitComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _submitComment,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: BrambleColors.primaryOrange,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x28C67139),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Color(0xFFFFF2EB),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
