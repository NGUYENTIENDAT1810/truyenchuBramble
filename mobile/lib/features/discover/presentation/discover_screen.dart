import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/bramble_chip.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'discover_controller.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoverControllerProvider);
    final notifier = ref.read(discoverControllerProvider.notifier);

    final heading = (state.query.isNotEmpty || state.selectedTag != 'All')
        ? '${state.books.length} RESULTS'
        : 'RISING THIS WEEK';

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover',
                style: BrambleTypography.displayLarge(color: BrambleColors.creamInk).copyWith(
                  fontSize: 31,
                ),
              ),
              const SizedBox(height: 14),

              // Search Bar
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: BrambleColors.creamSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: BrambleColors.creamMuted,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => notifier.setQuery(val),
                        style: BrambleTypography.bodyLarge(color: BrambleColors.creamInk),
                        decoration: InputDecoration(
                          hintText: 'Titles, authors, tags',
                          hintStyle: BrambleTypography.bodyLarge(color: BrambleColors.creamMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          notifier.setQuery('');
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: BrambleColors.creamMuted,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tag Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.tags.map((tag) {
                  final isSelected = state.selectedTag == tag;
                  return BrambleChip(
                    label: tag,
                    isSelected: isSelected,
                    onTap: () => notifier.setTag(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              // Rank Heading
              Text(
                heading,
                style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
              ),
              const SizedBox(height: 14),

              // Books List
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: BrambleLoading(),
                )
              else if (state.books.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No books found',
                      style: BrambleTypography.bodyMedium(color: BrambleColors.creamMuted),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.books.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final book = state.books[index];
                    final rankNumber = index + 1;

                    return GestureDetector(
                      onTap: () => context.push('/book/${book.id}'),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 26,
                            child: Text(
                              '$rankNumber',
                              style: BrambleTypography.displayMedium(
                                color: const Color(0xFFC0B6A5),
                              ).copyWith(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 8),
                          BookCoverView(
                            title: book.title,
                            coverColorHex: book.coverColor,
                            coverInkColorHex: book.coverInkColor,
                            width: 52,
                            height: 74,
                            borderRadius: 13,
                            showTitle: false,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: BrambleTypography.bodyMedium(
                                    color: BrambleColors.creamInk,
                                    fontWeight: FontWeight.w700,
                                  ).copyWith(fontSize: 15.5),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  book.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: BrambleTypography.bodySmall(
                                    color: BrambleColors.creamSubdued,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${book.totalChapters} ch · ${book.tag}',
                                  style: BrambleTypography.bodySmall(
                                    color: BrambleColors.creamMuted,
                                  ).copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
