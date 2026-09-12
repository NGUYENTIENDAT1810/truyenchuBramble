import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/presentation/auth_controller.dart';
import 'stats_controller.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);
    final user = ref.watch(authControllerProvider).user;
    final initial = user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'B';

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: statsAsync.when(
          loading: () => const BrambleLoading(message: 'Loading your reading insights...'),
          error: (err, _) => BrambleErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(userStatsProvider),
          ),
          data: (stats) {
            final todayMin = stats['todayMinutes'] ?? 27;
            final goalMin = stats['goalMinutes'] ?? 40;
            final statCards = stats['statCards'] as List? ?? [];
            final weekList = stats['week'] as List? ?? [];
            final peakInsight = stats['peakInsight'] ??
                'You read most between 21:00 and 23:00. Bramble delivers fresh chapters tailored to your reading time.';

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Editorial Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Your Reading',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: BrambleTypography.displayLarge(
                            color: BrambleColors.creamInk,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/settings'),
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: BrambleColors.creamSurface,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: BrambleColors.creamBorder.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.settings_outlined,
                                    size: 17,
                                    color: BrambleColors.creamInk,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Settings',
                                    style: BrambleTypography.bodySmall(
                                      color: BrambleColors.creamInk,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: BrambleColors.sageGreen,
                              border: Border.all(
                                color: BrambleColors.creamBg,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: BrambleTypography.titleMedium(
                                  color: const Color(0xFFF0FAE1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Today's Goal Ring Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrambleColors.creamSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: BrambleColors.creamBorder.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CustomPaint(
                            painter: _CircularProgressPainter(
                              progress: (todayMin / goalMin).clamp(0.0, 1.0),
                              strokeWidth: 9,
                              trackColor: BrambleColors.creamDivider,
                              progressColor: BrambleColors.primaryOrange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$todayMin of $goalMin min',
                                style: BrambleTypography.displaySmall(
                                  color: BrambleColors.creamInk,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Today's literary goal. You're making great daily progress!",
                                style: BrambleTypography.caption(
                                  color: BrambleColors.creamSubdued,
                                ).copyWith(height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3 Stat Cards
                  Row(
                    children: statCards.map((c) {
                      Color bg = BrambleColors.creamSurface;
                      Color ink = BrambleColors.creamInk;
                      final bgHex = c['bg'] as String?;
                      if (bgHex == '#ffe1d0') {
                        bg = BrambleColors.peachSelection;
                        ink = BrambleColors.peachDark;
                      } else if (bgHex == '#e1eecc') {
                        bg = BrambleColors.lightSage;
                        ink = BrambleColors.deepGreen;
                      }

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: BrambleColors.creamBorder.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c['value'] ?? '',
                                style: BrambleTypography.titleLarge(
                                  color: ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c['label'] ?? '',
                                style: BrambleTypography.caption(
                                  color: ink,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(fontSize: 10.5, letterSpacing: 0.2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // 7 Days Reading Habit Chart Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrambleColors.creamSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: BrambleColors.creamBorder.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WEEKLY READING HABIT',
                          style: BrambleTypography.labelUppercase(
                            color: BrambleColors.creamMuted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 96,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: weekList.map((d) {
                              final isToday = d['isToday'] == true;
                              final val = ((d['value'] as num?) ?? 50).toDouble() / 100.0;

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: FractionallySizedBox(
                                            heightFactor: val.clamp(0.12, 1.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: isToday
                                                    ? BrambleColors.primaryOrange
                                                    : BrambleColors.sageGreen,
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        d['label'] ?? '',
                                        style: BrambleTypography.caption(
                                          color: isToday
                                              ? BrambleColors.primaryOrangeDark
                                              : BrambleColors.creamMuted,
                                          fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                                        ).copyWith(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Insight Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: BrambleColors.lightSage,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: BrambleColors.sageGreen.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 20,
                          color: BrambleColors.deepGreen,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            peakInsight,
                            style: BrambleTypography.bodySmall(
                              color: BrambleColors.deepGreen,
                              fontWeight: FontWeight.w600,
                            ).copyWith(height: 1.5),
                          ),
                        ),
                      ],
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

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
