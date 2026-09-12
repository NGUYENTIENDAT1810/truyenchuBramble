import 'package:flutter/material.dart';
import '../theme/bramble_colors.dart';
import '../theme/bramble_typography.dart';

enum BrambleButtonVariant {
  primary,
  secondary,
  dark,
  peach,
  outline,
}

class BrambleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BrambleButtonVariant variant;
  final double height;
  final double? width;
  final Widget? icon;
  final bool isLoading;

  const BrambleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = BrambleButtonVariant.primary,
    this.height = 54,
    this.width,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Border? border;
    List<BoxShadow>? shadows;

    final isEnabled = onPressed != null && !isLoading;

    switch (variant) {
      case BrambleButtonVariant.primary:
        bg = isEnabled
            ? BrambleColors.primaryOrange
            : BrambleColors.creamDivider;
        fg = isEnabled ? const Color(0xFFFFF2EB) : BrambleColors.creamMuted;
        if (isEnabled) {
          shadows = [
            const BoxShadow(
              color: Color(0x282E2B25),
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ];
        }
        break;
      case BrambleButtonVariant.secondary:
        bg =
            isEnabled ? BrambleColors.creamSurface : BrambleColors.creamDivider;
        fg = isEnabled ? BrambleColors.creamInk : BrambleColors.creamMuted;
        break;
      case BrambleButtonVariant.dark:
        bg = isEnabled ? BrambleColors.deepGreen : BrambleColors.creamDivider;
        fg = isEnabled ? const Color(0xFFF0FAE1) : BrambleColors.creamMuted;
        break;
      case BrambleButtonVariant.peach:
        bg = isEnabled
            ? BrambleColors.peachSelection
            : BrambleColors.creamDivider;
        fg = isEnabled ? BrambleColors.peachDark : BrambleColors.creamMuted;
        break;
      case BrambleButtonVariant.outline:
        bg = Colors.transparent;
        fg = BrambleColors.creamInk;
        border = Border.all(
            color: BrambleColors.creamInk.withOpacity(0.3), width: 1.5);
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: border,
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: isEnabled ? onPressed : null,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          style: BrambleTypography.bodyLarge(
                            color: fg,
                            fontWeight: FontWeight.w700,
                          ).copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
