import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../data/book_repository.dart';
import 'cubit/book_detail_cubit.dart';

class ChapterListScreen extends StatelessWidget {
  final String bookId;

  const ChapterListScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookDetailCubit(
        bookRepository: context.read<BookRepository>(),
      )..loadBook(bookId),
      child: _ChapterListView(bookId: bookId),
    );
  }
}

class _ChapterListView extends StatefulWidget {
  final String bookId;

  const _ChapterListView({required this.bookId});

  @override
  State<_ChapterListView> createState() => _ChapterListViewState();
}

class _ChapterListViewState extends State<_ChapterListView> {
  bool _descending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: BlocBuilder<BookDetailCubit, BookDetailState>(
          builder: (context, state) {
            final book = state is BookDetailLoaded ? state.book : null;
            final chapters = state is BookDetailLoaded ? state.chapters : <Map<String, dynamic>>[];

            return Column(
              children: [
                // Header Bar
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
                              'Table of Contents',
                              style: BrambleTypography.titleLarge(
                                color: BrambleColors.creamInk,
                              ),
                            ),
                            if (book != null)
                              Text(
                                '${book.title} · ${book.totalChapters} chapters',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: BrambleTypography.caption(
                                  color: BrambleColors.creamMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Sort Order Button
                      GestureDetector(
                        onTap: () => setState(() => _descending = !_descending),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: BrambleColors.creamSurface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: BrambleColors.creamBorder.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _descending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                size: 14,
                                color: BrambleColors.creamInk,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _descending ? 'Newest' : 'Oldest',
                                style: BrambleTypography.caption(
                                  color: BrambleColors.creamInk,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chapter Items List
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is BookDetailLoading || state is BookDetailInitial) {
                        return const BrambleLoading(message: 'Loading table of contents...');
                      }

                      if (state is BookDetailFailure) {
                        return BrambleErrorView(
                          message: state.message,
                          onRetry: () => context.read<BookDetailCubit>().loadBook(widget.bookId),
                        );
                      }

                      if (chapters.isEmpty) {
                        return const BrambleEmptyState(
                          icon: Icons.list_alt_rounded,
                          title: 'No chapters available',
                          subtitle: 'Chapters will appear here once published by the author.',
                        );
                      }

                      final list = _descending ? chapters.reversed.toList() : chapters;

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => Divider(
                          color: BrambleColors.creamDivider.withOpacity(0.4),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final ch = list[index];
                          final isLocked = ch['isLocked'] == true;
                          final isFree = ch['isFree'] == true;

                          return GestureDetector(
                            onTap: () => context.push('/reader/${ch['id']}'),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 34,
                                    child: Text(
                                      '${ch['chapterNumber']}',
                                      style: BrambleTypography.titleMedium(
                                        color: isLocked
                                            ? BrambleColors.creamMuted.withOpacity(0.7)
                                            : BrambleColors.primaryOrange,
                                      ).copyWith(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ch['title'] ?? 'Chapter ${ch['chapterNumber']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: BrambleTypography.bodyMedium(
                                            color: isLocked
                                                ? BrambleColors.creamSubdued
                                                : BrambleColors.creamInk,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${ch['wordCount'] ?? 3400} words · ${isFree ? 'Free' : 'Premium'}',
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isLocked) ...[
                                          const Icon(
                                            Icons.lock_outline_rounded,
                                            size: 12,
                                            color: BrambleColors.peachDark,
                                          ),
                                          const SizedBox(width: 3),
                                        ],
                                        Text(
                                          isLocked ? '${ch['coinPrice'] ?? 30} coins' : 'Read',
                                          style: BrambleTypography.caption(
                                            color: isLocked
                                                ? BrambleColors.peachDark
                                                : BrambleColors.deepGreen,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
