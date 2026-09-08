import 'package:flutter/material.dart';
import '../theme/bramble_colors.dart';
import '../theme/bramble_typography.dart';

class BrambleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;

  const BrambleChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? BrambleColors.primaryOrange : BrambleColors.creamSurface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: BrambleTypography.bodySmall(
              color: isSelected ? const Color(0xFFFFF2EB) : const Color(0xFF474238),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
