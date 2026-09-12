import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'novel_detail_screen.dart';

final authorDetailProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, id) async {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getAuthorById(id);
});

class AuthorScreen extends ConsumerStatefulWidget {
  final String authorId;

  const AuthorScreen({super.key, required this.authorId});

  @override
  ConsumerState<AuthorScreen> createState() => _AuthorScreenState();
}

class _AuthorScreenState extends ConsumerState<AuthorScreen> {
  bool? _isFollowedOverride;

  void _toggleFollow(bool current) async {
    final newState = !current;
    setState(() => _isFollowedOverride = newState);
    final serverState = await ref.read(bookRepositoryProvider).toggleFollowAuthor(widget.authorId);
    setState(() => _isFollowedOverride = serverState);
  }

  @override
  Widget build(BuildContext context) {
    final authorAsync = ref.watch(authorDetailProvider(widget.authorId));

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: authorAsync.when(
          loading: () => const BrambleLoading(message: 'Loading author profile...'),
          error: (err, _) => BrambleErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(authorDetailProvider(widget.authorId)),
          ),
          data: (author) {
            final isFollowed = _isFollowedOverride ?? (author['isFollowed'] == true);
            final works = (author['works'] as List? ?? []);

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: GestureDetector(
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
                  ),

                  // Author Info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Circle
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: BrambleColors.oliveGreen,
                            border: Border.all(
                              color: BrambleColors.creamBg,
                              width: 3,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1F2E2B25),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              author['avatarInitial'] ?? 'A',
                              style: BrambleTypography.displayLarge(
                                color: const Color(0xFFF0FAE1),
                              ).copyWith(fontSize: 34),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          author['name'] ?? '',
                          style: BrambleTypography.displayMedium(
                            color: BrambleColors.creamInk,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${((author['followersCount'] ?? 14200) / 1000).toStringAsFixed(1)}k readers · ${author['novelsCount'] ?? 3} novels · joined ${author['joinedYear'] ?? 2021}',
                          style: BrambleTypography.caption(
                            color: BrambleColors.creamMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          author['bio'] ?? '',
                          style: BrambleTypography.bodyMedium(
                            color: BrambleColors.creamInk,
                          ).copyWith(height: 1.55),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: BrambleButton(
                                text: isFollowed ? 'Following' : 'Follow Author',
                                variant: isFollowed
                                    ? BrambleButtonVariant.dark
                                    : BrambleButtonVariant.primary,
                                height: 48,
                                onPressed: () => _toggleFollow(isFollowed),
                              ),
                            ),
                            const SizedBox(width: 10),
                            BrambleButton(
                              text: 'Support',
                              variant: BrambleButtonVariant.secondary,
                              height: 48,
                              width: 110,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: BrambleColors.creamSurface,
                                    content: Text(
                                      'Supported ${author['name']}!',
                                      style: BrambleTypography.bodyMedium(
                                        color: BrambleColors.creamInk,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Novels Section
                  if (works.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 26, 22, 0),
                      child: Text(
                        'NOVELS BY AUTHOR',
                        style: BrambleTypography.labelUppercase(
                          color: BrambleColors.creamMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 216,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        itemCount: works.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final work = works[index];
                          return GestureDetector(
                            onTap: () => context.push('/book/${work['id']}'),
                            child: SizedBox(
                              width: 112,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BookCoverView(
                                    title: work['title'] ?? '',
                                    coverUrl: work['coverUrl'] as String?,
                                    coverColorHex: work['coverColor'],
                                    coverInkColorHex: work['coverInkColor'],
                                    width: 112,
                                    height: 156,
                                    fontSize: 14,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    work['title'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: BrambleTypography.bodySmall(
                                      color: BrambleColors.creamInk,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    work['meta'] ?? '',
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
                  ],

                  // Note from Author card
                  if (author['authorNote'] != null && author['authorNote'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: BrambleColors.peachSelection,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: BrambleColors.primaryOrange.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note from ${author['name'].toString().split(' ').first}',
                              style: BrambleTypography.titleMedium(
                                color: BrambleColors.peachDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              author['authorNote'],
                              style: BrambleTypography.bodyMedium(
                                color: BrambleColors.peachDark,
                              ).copyWith(height: 1.55),
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
      ),
    );
  }
}
