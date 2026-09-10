import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'library_controller.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentLibraryTabProvider);
    final libraryAsync = ref.watch(libraryListProvider);
    final selection = ref.watch(librarySelectionProvider);
    final selectionNotifier = ref.read(librarySelectionProvider.notifier);

    final tabs = ['Reading', 'Saved', 'Downloaded'];

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                16,
                22,
                selection.isSelectMode && selection.selectedIds.isNotEmpty
                    ? 108
                    : 100,
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
                        ).copyWith(fontSize: 31),
                      ),
                      GestureDetector(
                        onTap: selectionNotifier.toggleSelectMode,
                        child: Text(
                          selection.isSelectMode ? 'Done' : 'Select',
                          style: BrambleTypography.bodySmall(
                            color: BrambleColors.primaryOrangeDark,
                            fontWeight: FontWeight.w700,
                          ).copyWith(fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Segmented Tabs Pill
                  Container(
                    height: 46,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: BrambleColors.creamSurface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: tabs.map((label) {
                        final isActive = currentTab == label;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => ref
                                .read(currentLibraryTabProvider.notifier)
                                .state = label,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? BrambleColors.creamBg
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: isActive
                                    ? const [
                                        BoxShadow(
                                          color: Color(0x242E2B25),
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
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
                                    fontWeight: FontWeight.w700,
                                  ).copyWith(fontSize: 13.5),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // List of books
                  Expanded(
                    child: libraryAsync.when(
                      loading: () =>
                          const BrambleLoading(message: 'Loading shelf...'),
                      error: (err, _) => BrambleErrorView(
                        message: err.toString(),
                        onRetry: () => ref.refresh(libraryListProvider),
                      ),
                      data: (items) {
                        if (items.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: BrambleColors.creamSurface,
                                  ),
                                  child: const Icon(
                                    Icons.auto_stories_outlined,
                                    size: 30,
                                    color: BrambleColors.creamMuted,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  currentTab == 'Saved'
                                      ? 'Nothing saved yet. Tap Save on a novel to keep it here.'
                                      : (currentTab == 'Downloaded'
                                          ? 'No chapters downloaded. Download from a novel page to read offline.'
                                          : 'No books reading currently.'),
                                  textAlign: TextAlign.center,
                                  style: BrambleTypography.bodyMedium(
                                    color: BrambleColors.creamMuted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: BrambleColors.primaryOrange,
                          backgroundColor: BrambleColors.creamBg,
                          onRefresh: () async =>
                              ref.refresh(libraryListProvider),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final book = (item['book'] is Map<String, dynamic>)
                                  ? item['book'] as Map<String, dynamic>
                                  : item;

                              final bookId = (book['id'] ?? item['bookId'] ?? item['id'])?.toString() ?? '';
                              final title = (book['title'] ?? item['title'] ?? 'Untitled').toString();
                              final author = (book['author'] ?? item['author'] ?? 'Unknown author').toString();
                              final totalChapters = book['totalChapters'] ?? item['totalChapters'] ?? 100;
                              final coverColor = book['coverColor']?.toString() ?? item['coverColor']?.toString();
                              final coverInkColor = book['coverInkColor']?.toString() ?? item['coverInkColor']?.toString();

                              final rawPct = item['progressPercent'] ?? item['pctValue'] ?? 0;
                              final pct = ((rawPct as num).toDouble()) / 100.0;
                              final lastChNum = item['lastReadChapterNumber'];
                              final stateText = (lastChNum != null && lastChNum > 0)
                                  ? 'Chapter $lastChNum of $totalChapters'
                                  : (currentTab == 'Downloaded'
                                      ? 'Available offline'
                                      : (pct > 0 ? '${(pct * 100).toInt()}% through' : 'Not started'));

                              final isSelected = selection.selectedIds.contains(bookId);
                              final isDownloading = selection.downloadingIds.contains(bookId);
                              final isDownloaded = selection.downloadedIds.contains(bookId);

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (selection.isSelectMode) ...[
                                    GestureDetector(
                                      onTap: () => selectionNotifier.toggleItem(bookId),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? BrambleColors.primaryOrange
                                              : BrambleColors.creamDivider,
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check_rounded,
                                                size: 16,
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
                                          selectionNotifier.toggleItem(bookId);
                                          return;
                                        }
                                        final lastCh = item['lastReadChapterId'] as String?;
                                        if (lastCh != null && lastCh.isNotEmpty) {
                                          context.push('/reader/$lastCh');
                                        } else {
                                          context.push('/book/$bookId');
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          BookCoverView(
                                            title: title,
                                            coverColorHex: coverColor,
                                            coverInkColorHex: coverInkColor,
                                            width: 62,
                                            height: 88,
                                            borderRadius: 14,
                                            showTitle: false,
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: SizedBox(
                                              height: 88,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: BrambleTypography.bodyMedium(
                                                          color: BrambleColors.creamInk,
                                                          fontWeight: FontWeight.w700,
                                                        ).copyWith(fontSize: 16),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        '$author · $totalChapters chapters',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: BrambleTypography.bodySmall(
                                                          color: BrambleColors.creamMuted,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // Progress bar
                                                      Container(
                                                        height: 5,
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
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        stateText,
                                                        style: BrambleTypography.bodySmall(
                                                          color: BrambleColors.creamMuted,
                                                        ).copyWith(fontSize: 11.5),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!selection.isSelectMode && currentTab != 'Downloaded') ...[
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => selectionNotifier.downloadOne(bookId),
                                      child: Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDownloaded
                                              ? BrambleColors.lightSage
                                              : BrambleColors.creamSurface,
                                        ),
                                        child: isDownloading
                                            ? const Center(
                                                child: SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.2,
                                                    color: BrambleColors.primaryOrange,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                isDownloaded
                                                    ? Icons.check_rounded
                                                    : Icons.download_rounded,
                                                size: 20,
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

            // Bulk Actions Footer when in Select Mode
            if (selection.isSelectMode && selection.selectedIds.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        BrambleColors.creamBg,
                        BrambleColors.creamBg.withOpacity(0.92),
                        BrambleColors.creamBg.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${selection.selectedIds.length} selected',
                        style: BrambleTypography.bodyMedium(
                          color: BrambleColors.creamSubdued,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: selectionNotifier.downloadSelected,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BrambleColors.primaryOrange,
                          foregroundColor: const Color(0xFFFFF2EB),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        child: const Text(
                          'Download',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: selectionNotifier.removeSelected,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE1D0),
                          foregroundColor: BrambleColors.primaryOrangeDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        ),
      ),
    );
  }
}
