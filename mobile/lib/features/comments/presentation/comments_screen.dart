import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../domain/comment_model.dart';
import 'comments_controller.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const CommentsScreen({super.key, required this.chapterId});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final _commentController = TextEditingController();
  final Map<String, int> _likeCounts = {};
  final Map<String, bool> _isLikedMap = {};

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    _commentController.clear();
    FocusScope.of(context).unfocus();

    try {
      final repo = ref.read(commentsRepositoryProvider);
      await repo.createComment(chapterId: widget.chapterId, content: text);
      ref.invalidate(chapterCommentsProvider(widget.chapterId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _toggleLike(CommentModel c) async {
    final currentLiked = _isLikedMap[c.id] ?? c.isLiked;
    final currentLikes = _likeCounts[c.id] ?? c.likes;

    setState(() {
      _isLikedMap[c.id] = !currentLiked;
      _likeCounts[c.id] = currentLiked ? (currentLikes - 1) : (currentLikes + 1);
    });

    try {
      final repo = ref.read(commentsRepositoryProvider);
      final isLiked = await repo.toggleLikeComment(c.id);
      setState(() => _isLikedMap[c.id] = isLiked);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(chapterCommentsProvider(widget.chapterId));

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: BrambleColors.creamBg,
                border: Border(
                  bottom: BorderSide(
                    color: BrambleColors.creamInk.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: BrambleColors.creamInk.withOpacity(0.06),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: BrambleColors.creamInk,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes & Comments',
                          style: BrambleTypography.displaySmall(
                            color: BrambleColors.creamInk,
                          ).copyWith(fontSize: 19),
                        ),
                        Text(
                          'Spoilers hidden · Tap to reveal',
                          style: BrambleTypography.bodySmall(
                            color: BrambleColors.creamMuted,
                          ).copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main List
            Expanded(
              child: commentsAsync.when(
                loading: () => const BrambleLoading(message: 'Loading comments...'),
                error: (err, _) => BrambleErrorView(
                  message: err.toString(),
                  onRetry: () => ref.refresh(chapterCommentsProvider(widget.chapterId)),
                ),
                data: (comments) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
                    children: [
                      // Top Tip Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: BrambleColors.lightSage,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          'Notes on paragraph 3 are the busiest. Tap a paragraph in the reader to jump straight to its thread.',
                          style: BrambleTypography.bodyMedium(
                            color: BrambleColors.deepGreen,
                            fontWeight: FontWeight.w500,
                          ).copyWith(fontSize: 13.5),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Comments items
                      ...comments.map((c) {
                        final isLiked = _isLikedMap[c.id] ?? c.isLiked;
                        final likesCount = _likeCounts[c.id] ?? c.likes;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: BrambleColors.primaryOrangeHover,
                                ),
                                child: Center(
                                  child: Text(
                                    c.initial,
                                    style: BrambleTypography.displaySmall(
                                      color: const Color(0xFFFFF2EB),
                                    ).copyWith(fontSize: 17),
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
                                          style: BrambleTypography.bodySmall(
                                            color: BrambleColors.creamMuted,
                                          ).copyWith(fontSize: 11.5),
                                        ),
                                      ],
                                    ),
                                    if (c.quote.isNotEmpty) ...[
                                      const SizedBox(height: 7),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: BrambleColors.creamSurface,
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Text(
                                          '“${c.quote}”',
                                          style: BrambleTypography.bodySmall(
                                            color: BrambleColors.creamSubdued,
                                          ).copyWith(fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 7),
                                    Text(
                                      c.text,
                                      style: BrambleTypography.bodyMedium(
                                        color: BrambleColors.creamInk,
                                      ).copyWith(fontSize: 14.5, height: 1.55),
                                    ),
                                    const SizedBox(height: 9),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _toggleLike(c),
                                          child: Container(
                                            height: 28,
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: isLiked
                                                  ? BrambleColors.primaryOrange
                                                  : BrambleColors.creamInk.withOpacity(0.06),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '♥ $likesCount',
                                                  style: BrambleTypography.bodySmall(
                                                    color: isLiked
                                                        ? const Color(0xFFFFF2EB)
                                                        : BrambleColors.creamSubdued,
                                                    fontWeight: FontWeight.w700,
                                                  ).copyWith(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          height: 28,
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: BrambleColors.creamInk.withOpacity(0.06),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Reply',
                                              style: BrambleTypography.bodySmall(
                                                color: BrambleColors.creamSubdued,
                                                fontWeight: FontWeight.w700,
                                              ).copyWith(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
              decoration: BoxDecoration(
                color: BrambleColors.creamBg,
                border: Border(
                  top: BorderSide(
                    color: BrambleColors.creamInk.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: BrambleTypography.bodyMedium(color: BrambleColors.creamInk),
                        decoration: InputDecoration(
                          hintText: 'Add a note…',
                          hintStyle: BrambleTypography.bodyMedium(color: BrambleColors.creamMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _submitComment,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: BrambleColors.primaryOrange,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Color(0xFFFFF2EB),
                          size: 22,
                        ),
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
