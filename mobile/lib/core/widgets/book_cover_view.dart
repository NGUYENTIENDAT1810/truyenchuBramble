import 'package:flutter/material.dart';
import '../theme/bramble_colors.dart';
import '../theme/bramble_typography.dart';

class BookCoverView extends StatelessWidget {
  final String title;
  final String? coverColorHex;
  final String? coverInkColorHex;
  final String? badge;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final bool showTitle;

  const BookCoverView({
    super.key,
    required this.title,
    this.coverColorHex,
    this.coverInkColorHex,
    this.badge,
    required this.width,
    required this.height,
    this.borderRadius = 16,
    this.fontSize = 15,
    this.showTitle = true,
  });

  Color _parseColor(String? hex, Color fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _parseColor(coverColorHex, BrambleColors.oliveGreen);
    final ink = _parseColor(coverInkColorHex, const Color(0xFFF0FAE1));

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x282E2B25),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Ornamental circle
            Positioned(
              top: -width * 0.2,
              right: -width * 0.2,
              child: Container(
                width: width * 0.75,
                height: width * 0.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                ),
              ),
            ),
            // Title text at bottom left
            if (showTitle)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: BrambleTypography.titleMedium(color: ink).copyWith(
                    fontSize: fontSize,
                    height: 1.05,
                  ),
                ),
              ),
            // Badge at top left
            if (badge != null && badge!.isNotEmpty)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: BrambleColors.primaryOrange,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                    child: Text(
                      badge!,
                      style: BrambleTypography.bodySmall(
                        color: const Color(0xFFFFF2EB),
                        fontWeight: FontWeight.w800,
                      ).copyWith(fontSize: 10, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
