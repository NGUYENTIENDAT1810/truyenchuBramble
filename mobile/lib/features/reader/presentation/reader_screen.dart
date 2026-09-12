import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_theme.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../comments/data/comments_repository.dart';
import '../../comments/presentation/cubit/comments_cubit.dart';
import '../data/reader_repository.dart';
import 'bloc/reader_bloc.dart';
import 'cubit/reader_settings_cubit.dart';
import 'paywall_sheet.dart';
import 'reader_settings_sheet.dart';

class ReaderScreen extends StatelessWidget {
  final String chapterId;

  const ReaderScreen({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReaderBloc>(
          create: (context) => ReaderBloc(
            readerRepository: context.read<ReaderRepository>(),
          )..add(ReaderChapterRequested(chapterId)),
        ),
        BlocProvider<CommentsCubit>(
          create: (context) => CommentsCubit(
            commentsRepository: context.read<CommentsRepository>(),
          )..loadComments(chapterId),
        ),
      ],
      child: _ReaderView(chapterId: chapterId),
    );
  }
}

class _ReaderView extends StatefulWidget {
  final String chapterId;

  const _ReaderView({required this.chapterId});

  @override
  State<_ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<_ReaderView> {
  final ScrollController _scrollController = ScrollController();
  bool _showChrome = true;
  double _readingProgress = 0.0;
  bool _isChapterLiked = false;
  Timer? _syncTimer;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll > 0) {
      final pct = (currentScroll / maxScroll).clamp(0.0, 1.0);
      setState(() => _readingProgress = pct);

      // Debounce progress sync
      _syncTimer?.cancel();
      _syncTimer = Timer(const Duration(seconds: 3), () {
        _syncProgressToBackend();
      });
    }
  }

  void _syncProgressToBackend() {
    final readerState = context.read<ReaderBloc>().state;
    if (readerState is ReaderLoaded) {
      final ch = readerState.chapterData;
      final elapsed = DateTime.now().difference(_startTime).inSeconds;
      final bookId = ch['bookId']?.toString() ?? '';
      if (bookId.isNotEmpty) {
        context.read<ReaderRepository>().syncProgress(
              bookId: bookId,
              chapterId: widget.chapterId,
              scrollOffset: _scrollController.hasClients
                  ? _scrollController.position.pixels
                  : 0,
              percentage: _readingProgress,
              deltaSeconds: elapsed,
            );
        _startTime = DateTime.now();
      }
    }
  }

  void _toggleChrome() {
    setState(() => _showChrome = !_showChrome);
  }

  void _openSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ReaderSettingsCubit>(),
        child: const ReaderSettingsSheet(),
      ),
    );
  }

  void _openPaywallSheet(Map<String, dynamic> nextCh) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaywallSheet(
        chapterId: nextCh['id'],
        chapterNumber: nextCh['chapterNumber'] ?? 48,
        chapterTitle: nextCh['title'] ?? 'Next Chapter',
        coinPrice: nextCh['coinPrice'] ?? 30,
        onUnlocked: () {
          context.read<ReaderBloc>().add(ReaderChapterUnlocked(nextCh['id']));
          context.pushReplacement('/reader/${nextCh['id']}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<ReaderSettingsCubit>().state;
    final themeConfig = ReaderThemeConfig.fromMode(settings.themeMode);

    return Scaffold(
      backgroundColor: themeConfig.bg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ReaderBloc, ReaderState>(
          builder: (context, state) {
            if (state is ReaderLoading || state is ReaderInitial) {
              return const BrambleLoading(message: 'Opening chapter...');
            }

            if (state is ReaderFailure) {
              return BrambleErrorView(
                message: state.message,
                onRetry: () => context
                    .read<ReaderBloc>()
                    .add(ReaderChapterRequested(widget.chapterId)),
              );
            }

            if (state is ReaderLoaded) {
              final chapter = state.chapterData;
              final isLocked = chapter['isLocked'] == true;
              final content = chapter['content'] as String? ?? '';
              final paragraphs = content
                  .split('\n\n')
                  .where((p) => p.trim().isNotEmpty)
                  .toList();

              final pctInt = (_readingProgress * 100).toInt();
              final wordCount =
                  (chapter['wordCount'] as num?)?.toDouble() ?? 3400.0;
              final estMinutes = math.max(
                1,
                ((wordCount * (1.0 - _readingProgress)) / 250).round(),
              );

              final nextCh = chapter['nextChapter'] as Map<String, dynamic>?;
              final prevCh = chapter['prevChapter'] as Map<String, dynamic>?;

              return Stack(
                children: [
                  // Reading content view
                  GestureDetector(
                    onTap: _toggleChrome,
                    behavior: HitTestBehavior.translucent,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(
                        settings.horizontalPadding,
                        _showChrome ? 68 : 28,
                        settings.horizontalPadding,
                        _showChrome ? 110 : 50,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chapter Number
                          Text(
                            'CHAPTER ${chapter['chapterNumber']}'.toUpperCase(),
                            style: BrambleTypography.labelUppercase(
                              color: themeConfig.muted,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Chapter Title
                          Text(
                            chapter['title'] ?? '',
                            style: BrambleTypography.displayMedium(
                              color: themeConfig.ink,
                            ).copyWith(fontSize: 28, height: 1.15),
                          ),
                          const SizedBox(height: 10),

                          // Chapter Metadata
                          Row(
                            children: [
                              Text(
                                '${chapter['wordCount'] ?? 3400} words',
                                style: BrambleTypography.caption(
                                  color: themeConfig.muted,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '·',
                                style: TextStyle(color: themeConfig.muted),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${estMinutes}m read',
                                style: BrambleTypography.caption(
                                  color: themeConfig.muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          if (isLocked) ...[
                            // Locked Paywall Placeholder
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: themeConfig.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: themeConfig.divider.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 40,
                                    color: BrambleColors.primaryOrange,
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'This chapter is locked',
                                    style: BrambleTypography.titleLarge(
                                      color: themeConfig.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Unlock this chapter with coins to continue reading.',
                                    textAlign: TextAlign.center,
                                    style: BrambleTypography.bodyMedium(
                                      color: themeConfig.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  BrambleButton(
                                    text:
                                        'Unlock for ${chapter['coinPrice'] ?? 30} coins',
                                    onPressed: () => _openPaywallSheet(chapter),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            // Paragraphs (Clean Editorial Text Reading Experience)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paragraphs.length,
                              itemBuilder: (context, index) {
                                final p = paragraphs[index];

                                final textStyle = settings.fontFamily == 'serif'
                                    ? BrambleTypography.readerSerif(
                                        fontSize: settings.fontSize,
                                        lineHeight: settings.lineHeight,
                                        color: themeConfig.ink,
                                      )
                                    : BrambleTypography.readerSans(
                                        fontSize: settings.fontSize,
                                        lineHeight: settings.lineHeight,
                                        color: themeConfig.ink,
                                      );

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 22),
                                  child: Text(
                                    p,
                                    style: textStyle,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 12),

                            // Interaction Bar at the end of reading content
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isChapterLiked = !_isChapterLiked;
                                    });
                                  },
                                  child: Container(
                                    height: 34,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: _isChapterLiked
                                          ? BrambleColors.primaryOrange
                                          : themeConfig.surface,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: _isChapterLiked
                                            ? BrambleColors.primaryOrange
                                            : themeConfig.divider
                                                .withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.favorite_rounded,
                                          size: 15,
                                          color: _isChapterLiked
                                              ? const Color(0xFFFFF2EB)
                                              : themeConfig.muted,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _isChapterLiked
                                              ? 'Liked'
                                              : 'Like Chapter',
                                          style: BrambleTypography.bodySmall(
                                            color: _isChapterLiked
                                                ? const Color(0xFFFFF2EB)
                                                : themeConfig.muted,
                                            fontWeight: FontWeight.w700,
                                          ).copyWith(fontSize: 12.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => context
                                      .push('/comments/${widget.chapterId}'),
                                  child: Container(
                                    height: 34,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: themeConfig.surface,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: themeConfig.divider
                                            .withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          size: 15,
                                          color: themeConfig.muted,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Comments',
                                          style: BrambleTypography.bodySmall(
                                            color: themeConfig.muted,
                                            fontWeight: FontWeight.w700,
                                          ).copyWith(fontSize: 12.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // End of Chapter Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: themeConfig.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: themeConfig.divider.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End of chapter ${chapter['chapterNumber']}',
                                    style: BrambleTypography.titleLarge(
                                      color: themeConfig.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (nextCh != null) ...[
                                    Text(
                                      nextCh['isLocked'] == true
                                          ? 'Chapter ${nextCh['chapterNumber']} is available to unlock.'
                                          : '“${nextCh['title']}” is ready to read.',
                                      style: BrambleTypography.bodyMedium(
                                        color: themeConfig.muted,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    BrambleButton(
                                      text: nextCh['isLocked'] == true
                                          ? 'Unlock Chapter ${nextCh['chapterNumber']}'
                                          : 'Next: Chapter ${nextCh['chapterNumber']}',
                                      onPressed: () {
                                        if (nextCh['isLocked'] == true) {
                                          _openPaywallSheet(nextCh);
                                        } else {
                                          context.pushReplacement(
                                              '/reader/${nextCh['id']}');
                                        }
                                      },
                                    ),
                                  ] else ...[
                                    Text(
                                      'You have caught up with the latest chapter!',
                                      style: BrambleTypography.bodyMedium(
                                        color: themeConfig.muted,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Comments Section Preview
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: themeConfig.divider.withOpacity(0.6),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Reader Notes',
                                        style: BrambleTypography.titleLarge(
                                          color: themeConfig.ink,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => context.push(
                                            '/comments/${widget.chapterId}'),
                                        child: Text(
                                          'View all →',
                                          style: BrambleTypography.bodySmall(
                                            color:
                                                BrambleColors.primaryOrangeDark,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  BlocBuilder<CommentsCubit, CommentsState>(
                                    builder: (context, commentsState) {
                                      if (commentsState is CommentsLoading) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: BrambleLoading(),
                                        );
                                      }

                                      if (commentsState is CommentsLoaded) {
                                        final comments = commentsState.comments;
                                        if (comments.isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              'No notes on this chapter yet. Be the first to share your thoughts!',
                                              style:
                                                  BrambleTypography.bodyMedium(
                                                color: themeConfig.muted,
                                              ),
                                            ),
                                          );
                                        }

                                        final preview =
                                            comments.take(2).toList();
                                        return Column(
                                          children: preview.map((c) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 14),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 34,
                                                    height: 34,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          themeConfig.surface,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        c.initial,
                                                        style: BrambleTypography
                                                            .bodyMedium(
                                                          color:
                                                              themeConfig.ink,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              c.name,
                                                              style:
                                                                  BrambleTypography
                                                                      .bodyMedium(
                                                                color:
                                                                    themeConfig
                                                                        .ink,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              c.time,
                                                              style:
                                                                  BrambleTypography
                                                                      .caption(
                                                                color:
                                                                    themeConfig
                                                                        .muted,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 3),
                                                        Text(
                                                          c.text,
                                                          style:
                                                              BrambleTypography
                                                                  .bodyMedium(
                                                            color:
                                                                themeConfig.ink,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }

                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Top Floating Chrome Bar
                  if (_showChrome)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: themeConfig.chrome,
                          border: Border(
                            bottom: BorderSide(
                              color: themeConfig.divider.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _syncProgressToBackend();
                                context.pop();
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeConfig.surface,
                                ),
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  color: themeConfig.ink,
                                  size: 26,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ch. ${chapter['chapterNumber']} · ${chapter['title']}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: BrambleTypography.bodyMedium(
                                  color: themeConfig.ink,
                                  fontWeight: FontWeight.w600,
                                ).copyWith(fontSize: 13.5),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => context
                                  .push('/book/${chapter['bookId']}/toc'),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeConfig.surface,
                                ),
                                child: Icon(
                                  Icons.format_list_bulleted_rounded,
                                  color: themeConfig.ink,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _openSettingsSheet,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeConfig.surface,
                                ),
                                child: Center(
                                  child: Text(
                                    'Aa',
                                    style: BrambleTypography.titleMedium(
                                      color: themeConfig.ink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Bottom Floating Chrome Bar with Navigation & Progress
                  if (_showChrome)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          18,
                          12,
                          18,
                          MediaQuery.of(context).padding.bottom > 0
                              ? MediaQuery.of(context).padding.bottom + 8
                              : 20,
                        ),
                        decoration: BoxDecoration(
                          color: themeConfig.chrome,
                          border: Border(
                            top: BorderSide(
                              color: themeConfig.divider.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: prevCh != null
                                          ? () => context.pushReplacement(
                                              '/reader/${prevCh['id']}')
                                          : null,
                                      child: Text(
                                        '← Prev Chapter',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: BrambleTypography.bodySmall(
                                          color: prevCh != null
                                              ? themeConfig.ink
                                              : themeConfig.muted
                                                  .withOpacity(0.5),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '$pctInt% · $estMinutes min left',
                                    style: BrambleTypography.caption(
                                      color: themeConfig.muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: nextCh != null
                                          ? () {
                                              if (nextCh['isLocked'] == true) {
                                                _openPaywallSheet(nextCh);
                                              } else {
                                                context.pushReplacement(
                                                    '/reader/${nextCh['id']}');
                                              }
                                            }
                                          : null,
                                      child: Text(
                                        'Next Chapter →',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: BrambleTypography.bodySmall(
                                          color: nextCh != null
                                              ? BrambleColors.primaryOrangeDark
                                              : themeConfig.muted
                                                  .withOpacity(0.5),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Progress Bar
                            Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeConfig.divider,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _readingProgress.clamp(0.02, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: BrambleColors.primaryOrange,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
