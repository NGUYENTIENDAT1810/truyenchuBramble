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
    final initial = user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'N';

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: statsAsync.when(
          loading: () => const BrambleLoading(message: 'Loading your reading statistics...'),
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
                'You read most between 21:00 and 23:00. Bramble now holds new chapters until then.';

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your reading',
                        style: BrambleTypography.displayLarge(
                          color: BrambleColors.creamInk,
                        ).copyWith(fontSize: 31),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/settings'),
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: BrambleColors.creamSurface,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.settings_outlined,
                                    size: 18,
                                    color: BrambleColors.creamSubdued,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'Settings',
                                    style: BrambleTypography.bodySmall(
                                      color: BrambleColors.creamInk,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(fontSize: 13.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: BrambleColors.sageGreen,
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: BrambleTypography.displaySmall(
                                  color: const Color(0xFFF0FAE1),
                                ).copyWith(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Today's Goal Ring Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrambleColors.creamSurface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 88,
                          height: 88,
                          child: CustomPaint(
                            painter: _CircularProgressPainter(
                              progress: (todayMin / goalMin).clamp(0.0, 1.0),
                              strokeWidth: 11,
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
                                style: BrambleTypography.displayMedium(
                                  color: BrambleColors.creamInk,
                                ).copyWith(fontSize: 27),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Today's goal. One more chapter does it.",
                                style: BrambleTypography.bodySmall(
                                  color: BrambleColors.creamSubdued,
                                ).copyWith(fontSize: 13.5, height: 1.45),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c['value'] ?? '',
                                style: BrambleTypography.displaySmall(
                                  color: ink,
                                ).copyWith(fontSize: 24),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c['label'] ?? '',
                                style: BrambleTypography.bodySmall(
                                  color: ink,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(fontSize: 11.5, letterSpacing: 0.2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // 7 Days Chart Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrambleColors.creamSurface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LAST 7 DAYS',
                          style: BrambleTypography.labelUppercase(
                            color: BrambleColors.creamMuted,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 104,
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
                                            heightFactor: val.clamp(0.15, 1.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: isToday
                                                    ? BrambleColors.primaryOrange
                                                    : const Color(0xFFAEBF92),
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        d['label'] ?? '',
                                        style: BrambleTypography.bodySmall(
                                          color: BrambleColors.creamMuted,
                                          fontWeight: FontWeight.w700,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: BrambleColors.lightSage,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      peakInsight,
                      style: BrambleTypography.bodyMedium(
                        color: BrambleColors.deepGreen,
                        fontWeight: FontWeight.w500,
                      ).copyWith(fontSize: 14, height: 1.55),
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
