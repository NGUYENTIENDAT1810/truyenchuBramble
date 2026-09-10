import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final String name;
  final String initial;
  final String colorHex;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.initial,
    this.colorHex = '#b2622d',
  });

  Color get _avatarColor {
    try {
      return Color(int.parse('FF${colorHex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return BrambleColors.primaryOrangeHover;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  child: const Icon(Icons.chevron_left_rounded, color: BrambleColors.creamInk, size: 28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: _avatarColor),
                    child: Center(
                      child: Text(
                        initial,
                        style: BrambleTypography.displayLarge(color: const Color(0xFFFFF2EB))
                            .copyWith(fontSize: 34),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    style: BrambleTypography.displayMedium(color: BrambleColors.creamInk)
                        .copyWith(fontSize: 27),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: BrambleColors.lightSage,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Center(
                      child: Text(
                        'READER',
                        style: BrambleTypography.bodySmall(
                          color: BrambleColors.deepGreen,
                          fontWeight: FontWeight.w800,
                        ).copyWith(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
