import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'novel_detail_screen.dart';

class ChapterListScreen extends ConsumerStatefulWidget {
  final String bookId;

  const ChapterListScreen({super.key, required this.bookId});

  @override
  ConsumerState<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends ConsumerState<ChapterListScreen> {
  bool _descending = true;

  @override
  Widget build(BuildContext context) {
    final bookAsync = ref.watch(bookDetailProvider(widget.bookId));
    final chaptersAsync = ref.watch(bookChaptersProvider(widget.bookId));

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
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
                          'Chapters',
                          style: BrambleTypography.displaySmall(
                            color: BrambleColors.creamInk,
                          ).copyWith(fontSize: 19),
                        ),
                        bookAsync.when(
                          data: (b) => Text(
                            '${b.totalChapters} chapters',
                            style: BrambleTypography.bodySmall(
                              color: BrambleColors.creamMuted,
                            ).copyWith(fontSize: 12),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  // Sort Order Button
                  GestureDetector(
                    onTap: () => setState(() => _descending = !_descending),
                    child: Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Center(
                        child: Text(
                          _descending ? 'Newest' : 'Oldest',
                          style: BrambleTypography.bodySmall(
                            color: BrambleColors.creamInk,
                            fontWeight: FontWeight.w700,
                          ).copyWith(fontSize: 12.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chapter items list
            Expanded(
              child: chaptersAsync.when(
                loading: () => const BrambleLoading(message: 'Loading table of contents...'),
                error: (err, _) => BrambleErrorView(
                  message: err.toString(),
                  onRetry: () => ref.refresh(bookChaptersProvider(widget.bookId)),
                ),
                data: (chapters) {
                  final list = _descending ? chapters.reversed.toList() : chapters;

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => Container(
                      height: 1,
                      color: BrambleColors.creamInk.withOpacity(0.08),
                    ),
                    itemBuilder: (context, index) {
                      final ch = list[index];
                      final isLocked = ch['isLocked'] == true;

                      return GestureDetector(
                        onTap: () => context.push('/reader/${ch['id']}'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '${ch['chapterNumber']}',
                                  style: BrambleTypography.displaySmall(
                                    color: const Color(0xFFC0B6A5),
                                  ).copyWith(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ch['title'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: BrambleTypography.bodyMedium(
                                        color: isLocked
                                            ? BrambleColors.creamMuted
                                            : BrambleColors.creamInk,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      isLocked
                                          ? 'Locked · ${ch['wordCount'] ?? 3400} words'
                                          : 'Read · ${ch['wordCount'] ?? 3400} words',
                                      style: BrambleTypography.bodySmall(
                                        color: BrambleColors.creamMuted,
                                      ).copyWith(fontSize: 11.5),
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
