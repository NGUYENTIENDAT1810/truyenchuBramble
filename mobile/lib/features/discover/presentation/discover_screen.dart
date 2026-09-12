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

    final isSearching = state.query.isNotEmpty || state.selectedTag != 'All';
    final heading = isSearching
        ? '${state.books.length} NOVELS FOUND'
        : 'RISING THIS WEEK';

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover',
                style: BrambleTypography.displayLarge(
                  color: BrambleColors.creamInk,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: BrambleColors.creamSurface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: BrambleColors.creamBorder.withOpacity(0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: BrambleColors.creamMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => notifier.setQuery(val),
                        style: BrambleTypography.bodyMedium(
                          color: BrambleColors.creamInk,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search titles, authors, genres...',
                          hintStyle: BrambleTypography.bodyMedium(
                            color: BrambleColors.creamMuted,
                          ),
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

              // Tag Filter Chips
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
              const SizedBox(height: 24),

              // Editorial Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    heading,
                    style: BrambleTypography.labelUppercase(
                      color: BrambleColors.creamMuted,
                    ),
                  ),
                  if (isSearching)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        notifier.setQuery('');
                        notifier.setTag('All');
                      },
                      child: Text(
                        'Reset',
                        style: BrambleTypography.caption(
                          color: BrambleColors.primaryOrangeDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Books Ranking List
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: BrambleLoading(message: 'Searching novels...'),
                )
              else if (state.books.isEmpty)
                BrambleEmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No novels found',
                  subtitle: 'Try searching with different keywords or genre filters.',
                  actionLabel: 'Clear filters',
                  onAction: () {
                    _searchController.clear();
                    notifier.setQuery('');
                    notifier.setTag('All');
                  },
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.books.length,
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      color: BrambleColors.creamDivider.withOpacity(0.6),
                      height: 1,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final book = state.books[index];
                    final rankNumber = index + 1;

                    return GestureDetector(
                      onTap: () => context.push('/book/${book.id}'),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Rank number
                          SizedBox(
                            width: 28,
                            child: Text(
                              '$rankNumber',
                              style: BrambleTypography.displayMedium(
                                color: rankNumber <= 3
                                    ? BrambleColors.primaryOrange
                                    : BrambleColors.creamBorder,
                              ).copyWith(fontSize: 22),
                            ),
                          ),
                          const SizedBox(width: 8),
                          BookCoverView(
                            title: book.title,
                            coverUrl: book.coverImageUrl,
                            coverColorHex: book.coverColor,
                            coverInkColorHex: book.coverInkColor,
                            width: 52,
                            height: 76,
                            borderRadius: 10,
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
                                  style: BrambleTypography.titleMedium(
                                    color: BrambleColors.creamInk,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  book.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: BrambleTypography.caption(
                                    color: BrambleColors.creamSubdued,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    if (book.tag.isNotEmpty) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: BrambleColors.creamSurface,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          book.tag,
                                          style: BrambleTypography.caption(
                                            color: BrambleColors.creamInk,
                                            fontWeight: FontWeight.w600,
                                          ).copyWith(fontSize: 10),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      '${book.totalChapters} ch',
                                      style: BrambleTypography.caption(
                                        color: BrambleColors.creamMuted,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          size: 14,
                                          color: BrambleColors.warning,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${book.rating}',
                                          style: BrambleTypography.caption(
                                            color: BrambleColors.creamInk,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
