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
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                    child: GestureDetector(
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
                  ),

                  // Author Info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Circle
                        Container(
                          width: 92,
                          height: 92,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: BrambleColors.oliveGreen,
                          ),
                          child: Center(
                            child: Text(
                              author['avatarInitial'] ?? 'A',
                              style: BrambleTypography.displayLarge(
                                color: const Color(0xFFF0FAE1),
                              ).copyWith(fontSize: 38),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          author['name'] ?? '',
                          style: BrambleTypography.displayMedium(
                            color: BrambleColors.creamInk,
                          ).copyWith(fontSize: 30),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${((author['followersCount'] ?? 14200) / 1000).toStringAsFixed(1)}k readers · ${author['novelsCount'] ?? 3} novels · joined ${author['joinedYear'] ?? 2021}',
                          style: BrambleTypography.bodySmall(
                            color: BrambleColors.creamMuted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          author['bio'] ?? '',
                          style: BrambleTypography.bodyMedium(
                            color: const Color(0xFF474238),
                          ).copyWith(fontSize: 15, height: 1.65),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: BrambleButton(
                                text: isFollowed ? 'Following' : 'Follow ${author['name']}',
                                variant: isFollowed
                                    ? BrambleButtonVariant.dark
                                    : BrambleButtonVariant.primary,
                                height: 50,
                                onPressed: () => _toggleFollow(isFollowed),
                              ),
                            ),
                            const SizedBox(width: 10),
                            BrambleButton(
                              text: 'Support',
                              variant: BrambleButtonVariant.secondary,
                              height: 50,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Supported ${author['name']}!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Novels Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 26, 22, 0),
                    child: Text(
                      'NOVELS',
                      style: BrambleTypography.labelUppercase(
                        color: BrambleColors.creamMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 210,
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
                            width: 104,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BookCoverView(
                                  title: work['title'] ?? '',
                                  coverColorHex: work['coverColor'],
                                  coverInkColorHex: work['coverInkColor'],
                                  width: 104,
                                  height: 148,
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
                                  ).copyWith(fontSize: 13),
                                ),
                                Text(
                                  work['meta'] ?? '',
                                  style: BrambleTypography.bodySmall(
                                    color: BrambleColors.creamMuted,
                                  ).copyWith(fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Note from Author card
                  if (author['authorNote'] != null && author['authorNote'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: BrambleColors.peachSelection,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note from ${author['name'].toString().split(' ').first}',
                              style: BrambleTypography.displaySmall(
                                color: BrambleColors.peachDark,
                              ).copyWith(fontSize: 19),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              author['authorNote'],
                              style: BrambleTypography.bodyMedium(
                                color: BrambleColors.peachDark,
                              ).copyWith(fontSize: 14, height: 1.55),
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
