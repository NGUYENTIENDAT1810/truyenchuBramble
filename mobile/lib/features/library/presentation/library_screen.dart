import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'bloc/library_bloc.dart';
import 'cubit/library_selection_cubit.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    final libraryBloc = context.read<LibraryBloc>();
    if (libraryBloc.state is LibraryInitial) {
      libraryBloc.add(const LibraryStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Reading', 'Saved', 'Downloaded'];

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<LibrarySelectionCubit, LibrarySelectionState>(
          builder: (context, selection) {
            final selectionCubit = context.read<LibrarySelectionCubit>();

            return BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                final currentTab = state.currentTab;

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        22,
                        16,
                        22,
                        selection.isSelectMode && selection.selectedIds.isNotEmpty
                            ? 110
                            : 110,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Library',
                                style: BrambleTypography.displayLarge(
                                  color: BrambleColors.creamInk,
                                ),
                              ),
                              GestureDetector(
                                onTap: selectionCubit.toggleSelectMode,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selection.isSelectMode
                                        ? BrambleColors.peachSelection
                                        : BrambleColors.creamSurface,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: BrambleColors.creamBorder.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    selection.isSelectMode ? 'Done' : 'Select',
                                    style: BrambleTypography.caption(
                                      color: selection.isSelectMode
                                          ? BrambleColors.primaryOrangeDark
                                          : BrambleColors.creamInk,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Segmented Tabs Pill
                          Container(
                            height: 44,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: BrambleColors.creamSurface,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: BrambleColors.creamBorder.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: tabs.map((label) {
                                final isActive = currentTab == label;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<LibraryBloc>().add(LibraryTabChanged(label));
                                      selectionCubit.reset();
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? BrambleColors.creamBg
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(999),
                                        boxShadow: isActive
                                            ? const [
                                                BoxShadow(
                                                  color: Color(0x1A2E2B25),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          label,
                                          style: BrambleTypography.bodySmall(
                                            color: isActive
                                                ? BrambleColors.creamInk
                                                : BrambleColors.creamMuted,
                                            fontWeight: isActive
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // List of Books
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (state is LibraryLoading || state is LibraryInitial) {
                                  return const BrambleLoading(message: 'Opening your library shelf...');
                                }

                                if (state is LibraryFailure) {
                                  return BrambleErrorView(
                                    message: state.message,
                                    onRetry: () => context.read<LibraryBloc>().add(LibraryTabChanged(currentTab)),
                                  );
                                }

                                final items = state is LibraryLoaded ? state.items : <Map<String, dynamic>>[];

                                if (items.isEmpty) {
                                  return BrambleEmptyState(
                                    icon: currentTab == 'Saved'
                                        ? Icons.bookmark_border_rounded
                                        : (currentTab == 'Downloaded'
                                            ? Icons.download_done_rounded
                                            : Icons.auto_stories_outlined),
                                    title: currentTab == 'Saved'
                                        ? 'No saved novels yet'
                                        : (currentTab == 'Downloaded'
                                            ? 'No offline chapters downloaded'
                                            : 'Your bookshelf is empty'),
                                    subtitle: currentTab == 'Saved'
                                        ? 'Tap bookmark on any novel to save it for later.'
                                        : (currentTab == 'Downloaded'
                                            ? 'Download chapters from novel pages to read offline without internet.'
                                            : 'Explore trending and featured novels to start reading.'),
                                    actionLabel: 'Explore Discover',
                                    onAction: () => context.go('/discover'),
                                  );
                                }

                                return RefreshIndicator(
                                  color: BrambleColors.primaryOrange,
                                  backgroundColor: BrambleColors.creamBg,
                                  onRefresh: () async {
                                    context.read<LibraryBloc>().add(const LibraryRefreshed());
                                  },
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    separatorBuilder: (_, __) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        color: BrambleColors.creamDivider.withOpacity(0.5),
                                        height: 1,
                                      ),
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      final book = (item['book'] is Map<String, dynamic>)
                                          ? item['book'] as Map<String, dynamic>
                                          : item;

                                      final bookId = (book['id'] ?? item['bookId'] ?? item['id'])?.toString() ?? '';
                                      final title = (book['title'] ?? item['title'] ?? 'Untitled').toString();
                                      final author = (book['author'] ?? item['author'] ?? 'Unknown author').toString();
                                      final totalChapters = book['totalChapters'] ?? item['totalChapters'] ?? 100;
                                      final coverUrl = (book['coverUrl'] ?? item['coverUrl'])?.toString();
                                      final coverColor = book['coverColor']?.toString() ?? item['coverColor']?.toString();
                                      final coverInkColor = book['coverInkColor']?.toString() ?? item['coverInkColor']?.toString();

                                      final rawPct = item['progressPercent'] ?? item['pctValue'] ?? 0;
                                      final pct = ((rawPct as num).toDouble()) / 100.0;
                                      final lastChNum = item['lastReadChapterNumber'];
                                      final stateText = (lastChNum != null && lastChNum > 0)
                                          ? 'Chapter $lastChNum of $totalChapters'
                                          : (currentTab == 'Downloaded'
                                              ? 'Available offline'
                                              : (pct > 0 ? '${(pct * 100).toInt()}% read' : 'Not started'));

                                      final isSelected = selection.selectedIds.contains(bookId);
                                      final isDownloading = selection.downloadingIds.contains(bookId);
                                      final isDownloaded = selection.downloadedIds.contains(bookId);

                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          if (selection.isSelectMode) ...[
                                            GestureDetector(
                                              onTap: () => selectionCubit.toggleItem(bookId),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 150),
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isSelected
                                                      ? BrambleColors.primaryOrange
                                                      : BrambleColors.creamSurface,
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? BrambleColors.primaryOrange
                                                        : BrambleColors.creamBorder,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: isSelected
                                                    ? const Icon(
                                                        Icons.check_rounded,
                                                        size: 15,
                                                        color: Colors.white,
                                                      )
                                                    : null,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (selection.isSelectMode) {
                                                  selectionCubit.toggleItem(bookId);
                                                  return;
                                                }
                                                final lastCh = item['lastReadChapterId'] as String?;
                                                if (lastCh != null && lastCh.isNotEmpty) {
                                                  context.push('/reader/$lastCh');
                                                } else {
                                                  context.push('/book/$bookId');
                                                }
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              child: Row(
                                                children: [
                                                  BookCoverView(
                                                    title: title,
                                                    coverUrl: coverUrl,
                                                    coverColorHex: coverColor,
                                                    coverInkColorHex: coverInkColor,
                                                    width: 58,
                                                    height: 84,
                                                    borderRadius: 10,
                                                    showTitle: false,
                                                  ),
                                                  const SizedBox(width: 14),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: BrambleTypography.titleMedium(
                                                            color: BrambleColors.creamInk,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          '$author · $totalChapters ch',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: BrambleTypography.caption(
                                                            color: BrambleColors.creamSubdued,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        // Progress bar
                                                        Container(
                                                          height: 4,
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                            color: BrambleColors.creamDivider,
                                                            borderRadius: BorderRadius.circular(999),
                                                          ),
                                                          child: FractionallySizedBox(
                                                            alignment: Alignment.centerLeft,
                                                            widthFactor: pct.clamp(0.0, 1.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: BrambleColors.sageGreen,
                                                                borderRadius: BorderRadius.circular(999),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          stateText,
                                                          style: BrambleTypography.caption(
                                                            color: BrambleColors.creamMuted,
                                                          ).copyWith(fontSize: 11),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (!selection.isSelectMode && currentTab != 'Downloaded') ...[
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () => selectionCubit.downloadOne(bookId),
                                              child: Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isDownloaded
                                                      ? BrambleColors.lightSage
                                                      : BrambleColors.creamSurface,
                                                  border: Border.all(
                                                    color: isDownloaded
                                                        ? BrambleColors.sageGreen.withOpacity(0.3)
                                                        : BrambleColors.creamBorder.withOpacity(0.4),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: isDownloading
                                                    ? const Center(
                                                        child: SizedBox(
                                                          width: 14,
                                                          height: 14,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: BrambleColors.primaryOrange,
                                                          ),
                                                        ),
                                                      )
                                                    : Icon(
                                                        isDownloaded
                                                            ? Icons.check_rounded
                                                            : Icons.download_rounded,
                                                        size: 18,
                                                        color: isDownloaded
                                                            ? BrambleColors.deepGreen
                                                            : BrambleColors.creamSubdued,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bulk Actions Footer in Select Mode
                    if (selection.isSelectMode && selection.selectedIds.isNotEmpty)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
                          decoration: BoxDecoration(
                            color: BrambleColors.creamSurface,
                            border: Border(
                              top: BorderSide(
                                color: BrambleColors.creamBorder.withOpacity(0.6),
                              ),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1F2E2B25),
                                blurRadius: 16,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${selection.selectedIds.length} selected',
                                style: BrambleTypography.bodyMedium(
                                  color: BrambleColors.creamInk,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: selectionCubit.downloadSelected,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: BrambleColors.primaryOrange,
                                  foregroundColor: const Color(0xFFFFF2EB),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                child: const Text(
                                  'Download',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: selectionCubit.removeSelected,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFE1D0),
                                  foregroundColor: BrambleColors.primaryOrangeDark,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
