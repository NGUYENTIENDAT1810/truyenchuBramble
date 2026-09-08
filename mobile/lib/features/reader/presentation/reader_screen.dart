import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_theme.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../comments/presentation/comments_controller.dart';
import 'paywall_sheet.dart';
import 'reader_controller.dart';
import 'reader_settings_sheet.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const ReaderScreen({super.key, required this.chapterId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showChrome = true;
  double _readingProgress = 0.0;
  final Map<int, bool> _paraLikes = {};
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
    final chapterAsync = ref.read(chapterContentProvider(widget.chapterId));
    chapterAsync.whenData((ch) {
      final elapsed = DateTime.now().difference(_startTime).inSeconds;
      ref.read(readerRepositoryProvider).syncProgress(
            bookId: ch['bookId'],
            chapterId: widget.chapterId,
            scrollOffset: _scrollController.hasClients ? _scrollController.position.pixels : 0,
            percentage: _readingProgress,
            deltaSeconds: elapsed,
          );
      _startTime = DateTime.now();
    });
  }

  void _toggleChrome() {
    setState(() => _showChrome = !_showChrome);
  }

  void _openSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReaderSettingsSheet(),
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
          ref.invalidate(chapterContentProvider(nextCh['id']));
          context.pushReplacement('/reader/${nextCh['id']}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final themeConfig = ReaderThemeConfig.fromMode(settings.themeMode);
    final chapterAsync = ref.watch(chapterContentProvider(widget.chapterId));
    final commentsAsync = ref.watch(chapterCommentsProvider(widget.chapterId));

    return Scaffold(
      backgroundColor: themeConfig.bg,
      body: SafeArea(
        bottom: false,
        child: chapterAsync.when(
          loading: () => const BrambleLoading(message: 'Opening chapter...'),
          error: (err, _) => BrambleErrorView(
            message: err.toString(),
            onRetry: () => ref.invalidate(chapterContentProvider(widget.chapterId)),
          ),
          data: (chapter) {
            final isLocked = chapter['isLocked'] == true;
            final content = chapter['content'] as String? ?? '';
            final paragraphs = content.split('\n\n').where((p) => p.trim().isNotEmpty).toList();

            final pctInt = (_readingProgress * 100).toInt();
            final wordCount = chapter['wordCount'] ?? 3400;
            final estMinutes = Math.max(1, ((wordCount * (1.0 - _readingProgress)) / 250).round());

            final nextCh = chapter['nextChapter'] as Map<String, dynamic>?;

            return Stack(
              children: [
                // Reading content
                GestureDetector(
                  onTap: _toggleChrome,
                  behavior: HitTestBehavior.translucent,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(
                      settings.horizontalPadding,
                      _showChrome ? 70 : 34,
                      settings.horizontalPadding,
                      _showChrome ? 90 : 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter numeral
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
                          ).copyWith(fontSize: 30, height: 1.12),
                        ),
                        const SizedBox(height: 22),

                        // If locked view
                        if (isLocked) ...[
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: themeConfig.surface,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chapter Locked',
                                  style: BrambleTypography.displaySmall(
                                    color: themeConfig.ink,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Unlock this chapter to continue reading the story.',
                                  style: BrambleTypography.bodyMedium(
                                    color: themeConfig.muted,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                BrambleButton(
                                  text: 'Unlock for ${chapter['coinPrice'] ?? 30} coins',
                                  onPressed: () => _openPaywallSheet(chapter),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Paragraphs
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: paragraphs.length,
                            itemBuilder: (context, index) {
                              final p = paragraphs[index];
                              final isLiked = _paraLikes[index] ?? false;

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
                                padding: const EdgeInsets.only(bottom: 19),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p,
                                      style: textStyle,
                                    ),
                                    const SizedBox(height: 6),
                                    // Paragraph interaction
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _paraLikes[index] = !isLiked;
                                            });
                                          },
                                          child: Container(
                                            height: 26,
                                            padding: const EdgeInsets.symmetric(horizontal: 11),
                                            decoration: BoxDecoration(
                                              color: isLiked
                                                  ? BrambleColors.primaryOrange
                                                  : themeConfig.ink.withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.favorite_rounded,
                                                  size: 13,
                                                  color: isLiked
                                                      ? const Color(0xFFFFF2EB)
                                                      : themeConfig.muted,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isLiked ? 'Liked' : 'Like',
                                                  style: BrambleTypography.bodySmall(
                                                    color: isLiked
                                                      ? const Color(0xFFFFF2EB)
                                                      : themeConfig.muted,
                                                    fontWeight: FontWeight.w700,
                                                  ).copyWith(fontSize: 11.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => context.push('/comments/${widget.chapterId}'),
                                          child: Container(
                                            height: 26,
                                            padding: const EdgeInsets.symmetric(horizontal: 11),
                                            decoration: BoxDecoration(
                                              color: themeConfig.ink.withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.chat_bubble_outline_rounded,
                                                  size: 13,
                                                  color: themeConfig.muted,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Note',
                                                  style: BrambleTypography.bodySmall(
                                                    color: themeConfig.muted,
                                                    fontWeight: FontWeight.w700,
                                                  ).copyWith(fontSize: 11.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // End of Chapter Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: themeConfig.surface.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End of chapter ${chapter['chapterNumber']}',
                                  style: BrambleTypography.displaySmall(
                                    color: themeConfig.ink,
                                  ).copyWith(fontSize: 20),
                                ),
                                const SizedBox(height: 6),
                                if (nextCh != null) ...[
                                  Text(
                                    nextCh['isLocked'] == true
                                        ? 'Chapter ${nextCh['chapterNumber']} unlocks in 6 hours, or open it now with coins.'
                                        : '“${nextCh['title']}” is ready to read.',
                                    style: BrambleTypography.bodyMedium(
                                      color: themeConfig.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  BrambleButton(
                                    text: nextCh['isLocked'] == true
                                        ? 'Unlock ch. ${nextCh['chapterNumber']}'
                                        : 'Next: Chapter ${nextCh['chapterNumber']}',
                                    onPressed: () {
                                      if (nextCh['isLocked'] == true) {
                                        _openPaywallSheet(nextCh);
                                      } else {
                                        context.pushReplacement('/reader/${nextCh['id']}');
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

                          const SizedBox(height: 30),

                          // Comments Section
                          Container(
                            padding: const EdgeInsets.only(top: 24),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: themeConfig.ink.withOpacity(0.15),
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Comments',
                                      style: BrambleTypography.displaySmall(
                                        color: themeConfig.ink,
                                      ).copyWith(fontSize: 21),
                                    ),
                                    Text(
                                      '${chapter['commentsCount'] ?? 218} on this chapter',
                                      style: BrambleTypography.bodySmall(
                                        color: themeConfig.muted,
                                        fontWeight: FontWeight.w700,
                                      ).copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Comment input bar
                                GestureDetector(
                                  onTap: () => context.push('/comments/${widget.chapterId}'),
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                                    decoration: BoxDecoration(
                                      color: themeConfig.surface,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Say something about chapter ${chapter['chapterNumber']}…',
                                            style: BrambleTypography.bodyMedium(
                                              color: themeConfig.muted,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: BrambleColors.primaryOrange,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_upward_rounded,
                                              color: Color(0xFFFFF2EB),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Top comments preview
                                commentsAsync.when(
                                  loading: () => const SizedBox.shrink(),
                                  error: (_, __) => const SizedBox.shrink(),
                                  data: (comments) {
                                    final top = comments.take(2).toList();
                                    return Column(
                                      children: top.map((c) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 38,
                                                height: 38,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: BrambleColors.primaryOrangeHover,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    c.initial,
                                                    style: BrambleTypography.displaySmall(
                                                      color: const Color(0xFFFFF2EB),
                                                    ).copyWith(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          c.name,
                                                          style: BrambleTypography.bodyMedium(
                                                            color: themeConfig.ink,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          c.time,
                                                          style: BrambleTypography.bodySmall(
                                                            color: themeConfig.muted,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      c.text,
                                                      style: BrambleTypography.bodyMedium(
                                                        color: themeConfig.ink,
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
                                  },
                                ),

                                const SizedBox(height: 8),
                                BrambleButton(
                                  text: 'See all comments',
                                  variant: BrambleButtonVariant.outline,
                                  onPressed: () => context.push('/comments/${widget.chapterId}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Top Chrome Bar
                if (_showChrome)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: themeConfig.chrome,
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
                                color: themeConfig.ink.withOpacity(0.06),
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
                              ).copyWith(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => context.push('/book/${chapter['bookId']}/toc'),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeConfig.ink.withOpacity(0.06),
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
                                color: themeConfig.ink.withOpacity(0.06),
                              ),
                              child: Center(
                                child: Text(
                                  'Aa',
                                  style: BrambleTypography.displaySmall(
                                    color: themeConfig.ink,
                                  ).copyWith(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bottom Chrome Progress Bar
                if (_showChrome)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                      decoration: BoxDecoration(
                        color: themeConfig.chrome,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: themeConfig.ink.withOpacity(0.18),
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
                          const SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$pctInt% · $estMinutes min left in chapter',
                                style: BrambleTypography.bodySmall(
                                  color: themeConfig.muted,
                                  fontWeight: FontWeight.w600,
                                ).copyWith(fontSize: 11.5),
                              ),
                              Text(
                                'Downloaded',
                                style: BrambleTypography.bodySmall(
                                  color: themeConfig.muted,
                                  fontWeight: FontWeight.w600,
                                ).copyWith(fontSize: 11.5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Math {
  static double max(double a, double b) => a > b ? a : b;
}
