import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/book_repository.dart';
import '../domain/book_detail_model.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return BookRepository(client);
});

final bookDetailProvider =
    FutureProvider.autoDispose.family<BookModel, String>((ref, id) async {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getBookById(id);
});

final bookChaptersProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, id) async {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getChaptersByBookId(id);
});

class NovelDetailScreen extends ConsumerStatefulWidget {
  final String bookId;

  const NovelDetailScreen({super.key, required this.bookId});

  @override
  ConsumerState<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends ConsumerState<NovelDetailScreen> {
  bool? _isSavedOverride;

  void _toggleSave(bool current) async {
    final newState = !current;
    setState(() => _isSavedOverride = newState);
    final serverState = await ref.read(bookRepositoryProvider).toggleSaveBook(widget.bookId);
    setState(() => _isSavedOverride = serverState);
  }

  @override
  Widget build(BuildContext context) {
    final bookAsync = ref.watch(bookDetailProvider(widget.bookId));
    final chaptersAsync = ref.watch(bookChaptersProvider(widget.bookId));

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: bookAsync.when(
          loading: () => const BrambleLoading(message: 'Loading novel...'),
          error: (err, _) => BrambleErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(bookDetailProvider(widget.bookId)),
          ),
          data: (book) {
            final isSaved = _isSavedOverride ?? book.isSaved;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                    child: GestureDetector(
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
                  ),

                  // Header: Cover + Meta
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BookCoverView(
                          title: book.title,
                          coverColorHex: book.coverColor,
                          coverInkColorHex: book.coverInkColor,
                          width: 122,
                          height: 174,
                          borderRadius: 22,
                          fontSize: 18,
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: BrambleTypography.displayMedium(
                                  color: BrambleColors.creamInk,
                                ).copyWith(fontSize: 25, height: 1.1),
                              ),
                              const SizedBox(height: 7),
                              GestureDetector(
                                onTap: () {
                                  if (book.authorId != null) {
                                    context.push('/author/${book.authorId}');
                                  }
                                },
                                child: Text(
                                  book.author,
                                  style: BrambleTypography.bodyMedium(
                                    color: BrambleColors.primaryOrangeDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 7,
                                runSpacing: 7,
                                children: [
                                  Container(
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: BrambleColors.peachSelection,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Center(
                                      child: Text(
                                        book.tag,
                                        style: BrambleTypography.bodySmall(
                                          color: BrambleColors.peachDark,
                                          fontWeight: FontWeight.w700,
                                        ).copyWith(fontSize: 11.5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: BrambleColors.lightSage,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Center(
                                      child: Text(
                                        book.status ?? 'Ongoing',
                                        style: BrambleTypography.bodySmall(
                                          color: BrambleColors.deepGreen,
                                          fontWeight: FontWeight.w700,
                                        ).copyWith(fontSize: 11.5),
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
                  ),

                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          _buildStatItem('${book.rating} ★', 'RATING'),
                          _buildStatItem('${book.totalChapters}', 'CHAPTERS'),
                          _buildStatItem('${(book.readersCount / 1000).toStringAsFixed(1)}k', 'READERS'),
                        ],
                      ),
                    ),
                  ),

                  // Blurb
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                    child: Text(
                      book.blurb,
                      style: BrambleTypography.bodyMedium(
                        color: const Color(0xFF474238),
                      ).copyWith(fontSize: 15, height: 1.65),
                    ),
                  ),

                  // Actions: Continue reading / Save
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: BrambleButton(
                            text: book.readingProgress != null
                                ? 'Continue ch. ${book.readingProgress!['chapterNumber'] ?? 1}'
                                : 'Start reading',
                            onPressed: () {
                              final chId = book.readingProgress?['chapterId'] as String?;
                              if (chId != null) {
                                context.push('/reader/$chId');
                              } else {
                                chaptersAsync.whenData((chapters) {
                                  if (chapters.isNotEmpty) {
                                    context.push('/reader/${chapters.first['id']}');
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        BrambleButton(
                          text: isSaved ? 'Saved' : 'Save',
                          variant: isSaved
                              ? BrambleButtonVariant.dark
                              : BrambleButtonVariant.secondary,
                          width: 100,
                          onPressed: () => _toggleSave(isSaved),
                        ),
                      ],
                    ),
                  ),

                  // Latest Chapters Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 26, 22, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'LATEST CHAPTERS',
                              style: BrambleTypography.labelUppercase(
                                color: BrambleColors.creamMuted,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/book/${widget.bookId}/toc'),
                              child: Text(
                                'All ${book.totalChapters}',
                                style: BrambleTypography.bodySmall(
                                  color: BrambleColors.primaryOrangeDark,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        chaptersAsync.when(
                          loading: () => const BrambleLoading(),
                          error: (e, _) => Text('Failed to load chapters: $e'),
                          data: (chapters) {
                            final latest = chapters.reversed.take(3).toList();
                            return Column(
                              children: latest.map((ch) {
                                final isLocked = ch['isLocked'] == true;
                                return GestureDetector(
                                  onTap: () => context.push('/reader/${ch['id']}'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: BrambleColors.creamInk.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ch. ${ch['chapterNumber']} · ${ch['title']}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: BrambleTypography.bodyMedium(
                                                  color: BrambleColors.creamInk,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                '${ch['wordCount'] ?? 3400} words',
                                                style: BrambleTypography.bodySmall(
                                                  color: BrambleColors.creamMuted,
                                                ).copyWith(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 24,
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: isLocked
                                                ? BrambleColors.peachSelection
                                                : BrambleColors.lightSage,
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Center(
                                            child: Text(
                                              isLocked ? '30 coins' : 'Read',
                                              style: BrambleTypography.bodySmall(
                                                color: isLocked
                                                    ? BrambleColors.peachDark
                                                    : BrambleColors.deepGreen,
                                                fontWeight: FontWeight.w800,
                                              ).copyWith(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: BrambleTypography.displaySmall(
              color: BrambleColors.creamInk,
            ).copyWith(fontSize: 21),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: BrambleTypography.labelUppercase(
              color: BrambleColors.creamMuted,
            ),
          ),
        ],
      ),
    );
  }
}
