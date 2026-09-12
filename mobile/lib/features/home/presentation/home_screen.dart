import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../books/domain/book_detail_model.dart';
import '../../notifications/presentation/notifications_controller.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

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
          loading: () => const HomeSkeletonView(),
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
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Editorial Greeting Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: BrambleTypography.caption(
                                    color: BrambleColors.creamMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Welcome, $userName',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: BrambleTypography.displayMedium(
                                    color: BrambleColors.creamInk,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              // Notification Bell
                              Consumer(
                                builder: (context, ref, _) {
                                  final hasUnread = ref.watch(notificationsUnreadProvider);
                                  return GestureDetector(
                                    onTap: () => context.push('/notifications'),
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
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Icon(
                                            Icons.notifications_outlined,
                                            size: 20,
                                            color: BrambleColors.creamInk,
                                          ),
                                          if (hasUnread)
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: BrambleColors.primaryOrange,
                                                  border: Border.all(
                                                    color: BrambleColors.creamBg,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              // Streak Badge
                              GestureDetector(
                                onTap: () => context.go('/stats'),
                                child: Container(
                                  height: 38,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: BrambleColors.lightSage,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: BrambleColors.sageGreen.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department_rounded,
                                        size: 18,
                                        color: BrambleColors.deepGreen,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$streak',
                                        style: BrambleTypography.bodySmall(
                                          color: BrambleColors.deepGreen,
                                          fontWeight: FontWeight.w800,
                                        ).copyWith(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Continue Reading Hero Section
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: BrambleColors.creamSurface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: BrambleColors.creamBorder.withOpacity(0.6),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x142E2B25),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => context.push('/book/${active['bookId']}'),
                                child: BookCoverView(
                                  title: active['bookTitle'] ?? 'Novel',
                                  coverUrl: active['coverUrl'] as String?,
                                  coverColorHex: active['coverColor'],
                                  coverInkColorHex: active['coverInkColor'],
                                  width: 82,
                                  height: 122,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      active['bookTitle'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: BrambleTypography.titleMedium(
                                        color: BrambleColors.creamInk,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${active['author'] ?? ''} · Ch. ${active['chapterNumber'] ?? 1}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: BrambleTypography.caption(
                                        color: BrambleColors.creamSubdued,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (active['chapterTitle'] != null &&
                                        active['chapterTitle'].toString().isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '“${active['chapterTitle']}”',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: BrambleTypography.bodySmall(
                                          color: BrambleColors.creamInk,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 10),
                                    // Progress Bar
                                    Container(
                                      height: 5,
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
                                            .clamp(0.04, 1.0),
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
                                          active['pctText'] ?? '0% read',
                                          style: BrambleTypography.caption(
                                            color: BrambleColors.creamMuted,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final chapterId = active['chapterId'] as String?;
                                            if (chapterId != null && chapterId.isNotEmpty) {
                                              context.push('/reader/$chapterId');
                                            } else {
                                              context.push('/book/${active['bookId']}');
                                            }
                                          },
                                          child: Text(
                                            'Resume →',
                                            style: BrambleTypography.bodySmall(
                                              color: BrambleColors.primaryOrangeDark,
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
                      ),
                      const SizedBox(height: 24),
                    ],

                    // New Chapters Today Section
                    if (newChapters.isNotEmpty) ...[
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 216,
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
                                width: 114,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BookCoverView(
                                      title: book.title,
                                      coverUrl: book.coverImageUrl,
                                      coverColorHex: book.coverColor,
                                      coverInkColorHex: book.coverInkColor,
                                      badge: book.badge,
                                      width: 114,
                                      height: 156,
                                      fontSize: 14,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      book.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: BrambleTypography.bodySmall(
                                        color: BrambleColors.creamInk,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      book.author,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: BrambleTypography.caption(
                                        color: BrambleColors.creamMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],

                    // Recommendations Section
                    if (recs.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          'CURATED RECOMMENDATIONS',
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
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => context.push('/book/${book.id}'),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
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
                                      BookCoverView(
                                        title: book.title,
                                        coverUrl: book.coverImageUrl,
                                        coverColorHex: book.coverColor,
                                        coverInkColorHex: book.coverInkColor,
                                        width: 50,
                                        height: 72,
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
                                              style: BrambleTypography.bodyMedium(
                                                color: BrambleColors.creamInk,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${book.author} · ${book.totalChapters} chapters',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BrambleTypography.caption(
                                                color: BrambleColors.creamSubdued,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                if (book.tag.isNotEmpty)
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: BrambleColors.lightSage,
                                                      borderRadius: BorderRadius.circular(999),
                                                    ),
                                                    child: Text(
                                                      book.tag,
                                                      style: BrambleTypography.caption(
                                                        color: BrambleColors.deepGreen,
                                                        fontWeight: FontWeight.w700,
                                                      ).copyWith(fontSize: 10.5),
                                                    ),
                                                  ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: BrambleColors.peachSelection,
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.star_rounded,
                                                        size: 12,
                                                        color: BrambleColors.peachDark,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        '${book.rating}',
                                                        style: BrambleTypography.caption(
                                                          color: BrambleColors.peachDark,
                                                          fontWeight: FontWeight.w700,
                                                        ).copyWith(fontSize: 10.5),
                                                      ),
                                                    ],
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
