import 'package:flutter/material.dart';
import '../theme/bramble_colors.dart';
import '../theme/bramble_typography.dart';

class BookCoverView extends StatelessWidget {
  final String title;
  final String? coverUrl;
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
    this.coverUrl,
    this.coverColorHex,
    this.coverInkColorHex,
    this.badge,
    required this.width,
    required this.height,
    this.borderRadius = 14,
    this.fontSize = 14.5,
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
            color: Color(0x1F2E2B25),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x0F2E2B25),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // If cover image URL is available and valid
            if (coverUrl != null && coverUrl!.startsWith('http'))
              Positioned.fill(
                child: Image.network(
                  coverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildEditorialFallback(bg, ink),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: bg,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: BrambleColors.primaryOrange,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              _buildEditorialFallback(bg, ink),

            // Book Spine Highlight Effect (Editorial Book Texture)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: width * 0.08,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.white.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
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
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      badge!,
                      style: BrambleTypography.caption(
                        color: const Color(0xFFFFF2EB),
                        fontWeight: FontWeight.w800,
                      ).copyWith(fontSize: 9.5, letterSpacing: 0.4),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorialFallback(Color bg, Color ink) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bg,
            Color.lerp(bg, Colors.black, 0.18) ?? bg,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Subtle literary ornament
          Positioned(
            top: -width * 0.25,
            right: -width * 0.25,
            child: Container(
              width: width * 0.85,
              height: width * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -width * 0.2,
            left: -width * 0.2,
            child: Container(
              width: width * 0.6,
              height: width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.08),
              ),
            ),
          ),
          // Inner frame border
          Positioned(
            top: 8,
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: ink.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius > 8 ? borderRadius - 6 : 4),
              ),
            ),
          ),
          // Title text at bottom
          if (showTitle)
            Positioned(
              bottom: 12,
              left: 14,
              right: 14,
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: BrambleTypography.titleMedium(color: ink).copyWith(
                  fontSize: fontSize,
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
