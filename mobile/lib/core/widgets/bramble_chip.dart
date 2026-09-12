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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? BrambleColors.primaryOrange
              : BrambleColors.creamSurface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: BrambleTypography.bodySmall(
            color:
                isSelected ? const Color(0xFFFFF2EB) : const Color(0xFF474238),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
