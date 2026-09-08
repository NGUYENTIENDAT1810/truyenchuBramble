import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../books/domain/book_detail_model.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeDataProvider);
    final user = ref.watch(authControllerProvider).user;
    final userName = user?.name.split(' ').first ?? 'Reader';

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: homeAsync.when(
          loading: () => const BrambleLoading(message: 'Loading your shelf...'),
          error: (err, _) => BrambleErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(homeDataProvider),
          ),
          data: (data) {
            final active = data['activeReading'] as Map<String, dynamic>?;
            final newChapters = data['newChapters'] as List<BookModel>;
            final recs = data['recommendations'] as List<BookModel>;
            final streak = data['streak'] ?? 12;

            return RefreshIndicator(
              color: BrambleColors.primaryOrange,
              backgroundColor: BrambleColors.creamBg,
              onRefresh: () async => ref.refresh(homeDataProvider),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Greeting Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wednesday evening',
                                  style: BrambleTypography.bodySmall(
                                    color: BrambleColors.creamMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Welcome back, $userName',
                                  style: BrambleTypography.displayLarge(
                                    color: BrambleColors.creamInk,
                                  ).copyWith(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          // Streak badge
                          GestureDetector(
                            onTap: () => context.go('/stats'),
                            child: Container(
                              height: 34,
                              padding: const EdgeInsets.symmetric(horizontal: 13),
                              decoration: BoxDecoration(
                                color: BrambleColors.lightSage,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: BrambleColors.mutedGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$streak',
                                    style: BrambleTypography.bodySmall(
                                      color: BrambleColors.deepGreen,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(fontSize: 13.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Continue Reading Section
                    if (active != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          'CONTINUE READING',
                          style: BrambleTypography.labelUppercase(
                            color: BrambleColors.creamMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 11),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: GestureDetector(
                          onTap: () {
                            final chapterId = active['chapterId'] as String?;
                            if (chapterId != null && chapterId.isNotEmpty) {
                              context.push('/reader/$chapterId');
                            } else {
                              context.push('/book/${active['bookId']}');
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: BrambleColors.creamSurface,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x282E2B25),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BookCoverView(
                                  title: active['bookTitle'] ?? 'Novel',
                                  coverColorHex: active['coverColor'],
                                  coverInkColorHex: active['coverInkColor'],
                                  width: 78,
                                  height: 112,
                                  fontSize: 14,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: SizedBox(
                                    height: 112,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              active['bookTitle'] ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BrambleTypography.displaySmall(
                                                color: BrambleColors.creamInk,
                                              ).copyWith(fontSize: 19),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${active['author'] ?? ''} · Chapter ${active['chapterNumber'] ?? 1}',
                                              style: BrambleTypography.bodySmall(
                                                color: BrambleColors.creamSubdued,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '“${active['chapterTitle'] ?? ''}”',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BrambleTypography.bodyMedium(
                                                color: BrambleColors.creamInk,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            // Progress bar
                                            Container(
                                              height: 6,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: BrambleColors.creamDivider,
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: FractionallySizedBox(
                                                alignment: Alignment.centerLeft,
                                                widthFactor: ((active['percentage'] is num)
                                                        ? (active['percentage'] as num).toDouble()
                                                        : 0.0)
                                                    .clamp(0.05, 1.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: BrambleColors.primaryOrange,
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  active['pctText'] ?? '0% through',
                                                  style: BrambleTypography.bodySmall(
                                                    color: BrambleColors.creamMuted,
                                                  ).copyWith(fontSize: 12),
                                                ),
                                                Text(
                                                  active['timeLeft'] ?? '',
                                                  style: BrambleTypography.bodySmall(
                                                    color: BrambleColors.creamMuted,
                                                  ).copyWith(fontSize: 12),
                                                ),
                                              ],
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
                      ),
                    ],

                    const SizedBox(height: 26),

                    // New chapters today
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'NEW CHAPTERS TODAY',
                            style: BrambleTypography.labelUppercase(
                              color: BrambleColors.creamMuted,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/library'),
                            child: Text(
                              'Library',
                              style: BrambleTypography.bodySmall(
                                color: BrambleColors.primaryOrangeDark,
                                fontWeight: FontWeight.w700,
                              ).copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 215,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        itemCount: newChapters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final book = newChapters[index];
                          return GestureDetector(
                            onTap: () => context.push('/book/${book.id}'),
                            child: SizedBox(
                              width: 112,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BookCoverView(
                                    title: book.title,
                                    coverColorHex: book.coverColor,
                                    coverInkColorHex: book.coverInkColor,
                                    badge: book.badge,
                                    width: 112,
                                    height: 158,
                                    fontSize: 15,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    book.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: BrambleTypography.bodySmall(
                                      color: BrambleColors.creamInk,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(fontSize: 13.5),
                                  ),
                                  Text(
                                    book.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: BrambleTypography.bodySmall(
                                      color: BrambleColors.creamMuted,
                                    ).copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Recommendations
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        'BECAUSE YOU READ SLOW FANTASY',
                        style: BrambleTypography.labelUppercase(
                          color: BrambleColors.creamMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: recs.map((book) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () => context.push('/book/${book.id}'),
                              child: Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: BrambleColors.creamSurface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    BookCoverView(
                                      title: book.title,
                                      coverColorHex: book.coverColor,
                                      coverInkColorHex: book.coverInkColor,
                                      width: 46,
                                      height: 64,
                                      borderRadius: 12,
                                      showTitle: false,
                                    ),
                                    const SizedBox(width: 13),
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
                                            ).copyWith(fontSize: 15),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${book.author} · ${book.totalChapters} chapters',
                                            style: BrambleTypography.bodySmall(
                                              color: BrambleColors.creamSubdued,
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          Row(
                                            children: [
                                              Container(
                                                height: 21,
                                                padding: const EdgeInsets.symmetric(horizontal: 9),
                                                decoration: BoxDecoration(
                                                  color: BrambleColors.lightSage,
                                                  borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    book.tag,
                                                    style: BrambleTypography.bodySmall(
                                                      color: BrambleColors.deepGreen,
                                                      fontWeight: FontWeight.w700,
                                                    ).copyWith(fontSize: 11),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                height: 21,
                                                padding: const EdgeInsets.symmetric(horizontal: 9),
                                                decoration: BoxDecoration(
                                                  color: BrambleColors.peachSelection,
                                                  borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${book.rating} ★',
                                                    style: BrambleTypography.bodySmall(
                                                      color: BrambleColors.peachDark,
                                                      fontWeight: FontWeight.w700,
                                                    ).copyWith(fontSize: 11),
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
