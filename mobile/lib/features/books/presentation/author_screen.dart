import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/book_cover_view.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../data/book_repository.dart';
import 'cubit/author_detail_cubit.dart';

class AuthorScreen extends StatelessWidget {
  final String authorId;

  const AuthorScreen({super.key, required this.authorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthorDetailCubit(
        bookRepository: context.read<BookRepository>(),
      )..loadAuthor(authorId),
      child: _AuthorView(authorId: authorId),
    );
  }
}

class _AuthorView extends StatelessWidget {
  final String authorId;

  const _AuthorView({required this.authorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: BlocBuilder<AuthorDetailCubit, AuthorDetailState>(
          builder: (context, state) {
            if (state is AuthorDetailLoading || state is AuthorDetailInitial) {
              return const BrambleLoading(message: 'Loading author profile...');
            }

            if (state is AuthorDetailFailure) {
              return BrambleErrorView(
                message: state.message,
                onRetry: () => context.read<AuthorDetailCubit>().loadAuthor(authorId),
              );
            }

            if (state is AuthorDetailLoaded) {
              final author = state.authorData;
              final isFollowed = state.isFollowed;
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
                                  color: Color(0x1A2E2B25),
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                author['avatarInitial'] ?? 'A',
                                style: BrambleTypography.displayLarge(
                                  color: const Color(0xFFE4EAD7),
                                ).copyWith(fontSize: 34),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            author['name'] ?? 'Author',
                            style: BrambleTypography.displayMedium(
                              color: BrambleColors.creamInk,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${author['followersCount'] ?? 0} followers · ${works.length} serials',
                            style: BrambleTypography.caption(
                              color: BrambleColors.creamMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            author['bio'] ?? '',
                            style: BrambleTypography.bodyMedium(
                              color: BrambleColors.creamSubdued,
                            ).copyWith(height: 1.5),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: BrambleButton(
                                  text: isFollowed ? 'Following' : 'Follow',
                                  variant: isFollowed
                                      ? BrambleButtonVariant.dark
                                      : BrambleButtonVariant.primary,
                                  height: 44,
                                  onPressed: () {
                                    context.read<AuthorDetailCubit>().toggleFollow(authorId);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: BrambleButton(
                                  text: 'Support',
                                  variant: BrambleButtonVariant.peach,
                                  height: 44,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Support author with Bramble coins feature coming soon!'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Author Works Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        'WORKS BY THIS AUTHOR',
                        style: BrambleTypography.labelUppercase(
                          color: BrambleColors.creamMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (works.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                        child: Text(
                          'No serials published under this name yet.',
                          style: BrambleTypography.bodyMedium(
                            color: BrambleColors.creamMuted,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          children: works.map((w) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => context.push('/book/${w['id']}'),
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
                                        title: w['title'] ?? 'Novel',
                                        coverUrl: w['coverImageUrl'] as String?,
                                        coverColorHex: w['coverColor'],
                                        coverInkColorHex: w['coverInkColor'],
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
                                              w['title'] ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BrambleTypography.bodyMedium(
                                                color: BrambleColors.creamInk,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${w['totalChapters'] ?? 0} chapters · ${w['status'] ?? 'Ongoing'}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BrambleTypography.caption(
                                                color: BrambleColors.creamSubdued,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              w['tag'] ?? '',
                                              style: BrambleTypography.caption(
                                                color: BrambleColors.deepGreen,
                                                fontWeight: FontWeight.w700,
                                              ).copyWith(fontSize: 11),
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

                    const SizedBox(height: 24),

                    // Author Note / Newsletter Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: BrambleColors.creamSurface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: BrambleColors.creamBorder.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.edit_note_rounded,
                                  color: BrambleColors.primaryOrange,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AUTHOR NOTE',
                                  style: BrambleTypography.labelUppercase(
                                    color: BrambleColors.primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              author['authorNote'] ??
                                  'Thank you for reading along! New chapters are written and published twice weekly on Wednesdays and Saturdays.',
                              style: BrambleTypography.bodyMedium(
                                color: BrambleColors.creamInk,
                              ).copyWith(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
