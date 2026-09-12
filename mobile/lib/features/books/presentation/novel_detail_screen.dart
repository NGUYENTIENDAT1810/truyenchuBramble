import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../data/book_repository.dart';
import 'cubit/book_detail_cubit.dart';

class NovelDetailScreen extends StatelessWidget {
  final String bookId;

  const NovelDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookDetailCubit(
        bookRepository: context.read<BookRepository>(),
      )..loadBook(bookId),
      child: _NovelDetailView(bookId: bookId),
    );
  }
}

class _NovelDetailView extends StatefulWidget {
  final String bookId;

  const _NovelDetailView({required this.bookId});

  @override
  State<_NovelDetailView> createState() => _NovelDetailViewState();
}

class _NovelDetailViewState extends State<_NovelDetailView> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: BlocBuilder<BookDetailCubit, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoading || state is BookDetailInitial) {
              return const BrambleLoading(message: 'Loading novel details...');
            }

            if (state is BookDetailFailure) {
              return BrambleErrorView(
                message: state.message,
                onRetry: () => context.read<BookDetailCubit>().loadBook(widget.bookId),
              );
            }

            if (state is BookDetailLoaded) {
              final book = state.book;
              final chapters = state.chapters;
              final isSaved = state.isSaved;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          GestureDetector(
                            onTap: () {
                              context.read<BookDetailCubit>().toggleSave(widget.bookId);
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSaved
                                    ? BrambleColors.peachSelection
                                    : BrambleColors.creamSurface,
                                border: Border.all(
                                  color: BrambleColors.creamBorder.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                                color: isSaved
                                    ? BrambleColors.primaryOrange
                                    : BrambleColors.creamInk,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Header Editorial Layout: Cover + Meta
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BookCoverView(
                            title: book.title,
                            coverUrl: book.coverImageUrl,
                            coverColorHex: book.coverColor,
                            coverInkColorHex: book.coverInkColor,
                            width: 116,
                            height: 168,
                            borderRadius: 14,
                            fontSize: 16,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: BrambleTypography.displaySmall(
                                    color: BrambleColors.creamInk,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {
                                    if (book.authorId != null) {
                                      context.push('/author/${book.authorId}');
                                    }
                                  },
                                  child: Text(
                                    book.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: BrambleTypography.bodyMedium(
                                      color: BrambleColors.primaryOrangeDark,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    if (book.tag.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: BrambleColors.peachSelection,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          book.tag,
                                          style: BrambleTypography.caption(
                                            color: BrambleColors.peachDark,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: BrambleColors.lightSage,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        book.status ?? 'Ongoing',
                                        style: BrambleTypography.caption(
                                          color: BrambleColors.deepGreen,
                                          fontWeight: FontWeight.w700,
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
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: BrambleColors.creamSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: BrambleColors.creamBorder.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildStatItem('${book.rating} ★', 'RATING'),
                            Container(
                              width: 1,
                              height: 28,
                              color: BrambleColors.creamDivider,
                            ),
                            _buildStatItem('${book.totalChapters}', 'CHAPTERS'),
                            Container(
                              width: 1,
                              height: 28,
                              color: BrambleColors.creamDivider,
                            ),
                            _buildStatItem(
                              book.readersCount > 1000
                                  ? '${(book.readersCount / 1000).toStringAsFixed(1)}k'
                                  : '${book.readersCount}',
                              'READERS',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Synopsis / Blurb
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SYNOPSIS',
                            style: BrambleTypography.labelUppercase(
                              color: BrambleColors.creamMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.blurb,
                                  maxLines: _isDescriptionExpanded ? null : 4,
                                  overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                  style: BrambleTypography.bodyMedium(
                                    color: BrambleColors.creamInk,
                                  ).copyWith(height: 1.55),
                                ),
                                if (book.blurb.length > 180) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _isDescriptionExpanded ? 'Show less' : 'Read more',
                                    style: BrambleTypography.caption(
                                      color: BrambleColors.primaryOrangeDark,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Primary Reading CTA & Save Action
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: BrambleButton(
                              text: book.readingProgress != null
                                  ? 'Continue ch. ${book.readingProgress!['chapterNumber'] ?? 1}'
                                  : 'Start Reading',
                              height: 50,
                              onPressed: () {
                                final chId = book.readingProgress?['chapterId'] as String?;
                                if (chId != null && chId.isNotEmpty) {
                                  context.push('/reader/$chId');
                                } else if (chapters.isNotEmpty) {
                                  context.push('/reader/${chapters.first['id']}');
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
                            height: 50,
                            width: 96,
                            onPressed: () {
                              context.read<BookDetailCubit>().toggleSave(widget.bookId);
                            },
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
                                  'All ${book.totalChapters} →',
                                  style: BrambleTypography.bodySmall(
                                    color: BrambleColors.primaryOrangeDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (chapters.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'No chapters published yet.',
                                style: BrambleTypography.bodyMedium(
                                  color: BrambleColors.creamMuted,
                                ),
                              ),
                            )
                          else
                            Column(
                              children: chapters.reversed.take(3).map((ch) {
                                final isLocked = ch['isLocked'] == true;
                                return GestureDetector(
                                  onTap: () => context.push('/reader/${ch['id']}'),
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: BrambleColors.creamDivider.withOpacity(0.6),
                                          width: 1,
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
                                              const SizedBox(height: 2),
                                              Text(
                                                '${ch['wordCount'] ?? 3400} words',
                                                style: BrambleTypography.caption(
                                                  color: BrambleColors.creamMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          height: 26,
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: isLocked
                                                ? BrambleColors.peachSelection
                                                : BrambleColors.lightSage,
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Center(
                                            child: Text(
                                              isLocked ? '${ch['coinPrice'] ?? 30} coins' : 'Read',
                                              style: BrambleTypography.caption(
                                                color: isLocked
                                                    ? BrambleColors.peachDark
                                                    : BrambleColors.deepGreen,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
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
            style: BrambleTypography.titleLarge(
              color: BrambleColors.creamInk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: BrambleTypography.caption(
              color: BrambleColors.creamMuted,
              fontWeight: FontWeight.w700,
            ).copyWith(fontSize: 10, letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }
}
