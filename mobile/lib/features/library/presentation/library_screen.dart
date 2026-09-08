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

    final tabs = ['Reading', 'Saved', 'Downloaded'];

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Library',
                style: BrambleTypography.displayLarge(color: BrambleColors.creamInk).copyWith(
                  fontSize: 31,
                ),
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
                        onTap: () => ref.read(currentLibraryTabProvider.notifier).state = label,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isActive ? BrambleColors.creamBg : Colors.transparent,
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
                                color: isActive ? BrambleColors.creamInk : BrambleColors.creamMuted,
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
                  loading: () => const BrambleLoading(message: 'Loading shelf...'),
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
                              'No books in this tab yet',
                              style: BrambleTypography.bodyMedium(color: BrambleColors.creamMuted),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: BrambleColors.primaryOrange,
                      backgroundColor: BrambleColors.creamBg,
                      onRefresh: () async => ref.refresh(libraryListProvider),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final pct = ((item['pctValue'] as num?) ?? 0) / 100.0;

                          return GestureDetector(
                            onTap: () {
                              final lastCh = item['lastReadChapterId'] as String?;
                              if (lastCh != null && lastCh.isNotEmpty) {
                                context.push('/reader/$lastCh');
                              } else {
                                context.push('/book/${item['id']}');
                              }
                            },
                            child: Row(
                              children: [
                                BookCoverView(
                                  title: item['title'] ?? '',
                                  coverColorHex: item['coverColor'],
                                  coverInkColorHex: item['coverInkColor'],
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
                                              item['title'] ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BrambleTypography.bodyMedium(
                                                color: BrambleColors.creamInk,
                                                fontWeight: FontWeight.w700,
                                              ).copyWith(fontSize: 16),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              item['sub'] ?? '',
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
                                              item['state'] ?? '',
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
      ),
    );
  }
}
