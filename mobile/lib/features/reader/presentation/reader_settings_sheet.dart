import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_theme.dart';
import '../../../core/theme/bramble_typography.dart';
import 'reader_controller.dart';

class ReaderSettingsSheet extends ConsumerWidget {
  const ReaderSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    final notifier = ref.read(readerSettingsProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 38),
      decoration: const BoxDecoration(
        color: BrambleColors.creamBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x382E2B25),
            blurRadius: 32,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: BrambleColors.creamDivider,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reading',
                style: BrambleTypography.displaySmall(
                  color: BrambleColors.creamInk,
                ).copyWith(fontSize: 23),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Done',
                  style: BrambleTypography.bodyMedium(
                    color: BrambleColors.primaryOrangeDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Themes
          Text(
            'THEME',
            style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildThemeCard(
                label: 'Cream',
                mode: ReaderThemeMode.cream,
                bg: const Color(0xFFF5EAD8),
                ink: const Color(0xFF201E1D),
                isSelected: settings.themeMode == ReaderThemeMode.cream,
                onTap: () => notifier.setTheme(ReaderThemeMode.cream),
              ),
              const SizedBox(width: 10),
              _buildThemeCard(
                label: 'Sepia',
                mode: ReaderThemeMode.sepia,
                bg: const Color(0xFFE8D7B4),
                ink: const Color(0xFF3A2C17),
                isSelected: settings.themeMode == ReaderThemeMode.sepia,
                onTap: () => notifier.setTheme(ReaderThemeMode.sepia),
              ),
              const SizedBox(width: 10),
              _buildThemeCard(
                label: 'Night',
                mode: ReaderThemeMode.night,
                bg: const Color(0xFF211F1C),
                ink: const Color(0xFFE7DFD1),
                isSelected: settings.themeMode == ReaderThemeMode.night,
                onTap: () => notifier.setTheme(ReaderThemeMode.night),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Typeface
          Text(
            'TYPEFACE',
            style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
          ),
          const SizedBox(height: 10),
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: BrambleColors.creamSurface,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                _buildTypefaceOption(
                  label: 'Lora',
                  isSerif: true,
                  isSelected: settings.fontFamily == 'serif',
                  onTap: () => notifier.setFontFamily('serif'),
                ),
                _buildTypefaceOption(
                  label: 'Figtree',
                  isSerif: false,
                  isSelected: settings.fontFamily == 'sans',
                  onTap: () => notifier.setFontFamily('sans'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Text Size Stepper
          _buildStepper(
            label: 'Text size',
            value: '${settings.fontSize.toInt()}px',
            onDec: () => notifier.setFontSize(settings.fontSize - 1),
            onInc: () => notifier.setFontSize(settings.fontSize + 1),
          ),
          const SizedBox(height: 14),

          // Line Spacing Stepper
          _buildStepper(
            label: 'Line spacing',
            value: settings.lineHeight.toStringAsFixed(2),
            onDec: () => notifier.setLineHeight(settings.lineHeight - 0.15),
            onInc: () => notifier.setLineHeight(settings.lineHeight + 0.15),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard({
    required String label,
    required ReaderThemeMode mode,
    required Color bg,
    required Color ink,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected ? BrambleColors.primaryOrange : BrambleColors.creamInk.withOpacity(0.14),
              width: isSelected ? 2.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aa',
                style: BrambleTypography.displaySmall(color: ink).copyWith(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: BrambleTypography.bodySmall(
                  color: ink,
                  fontWeight: FontWeight.w700,
                ).copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypefaceOption({
    required String label,
    required bool isSerif,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isSelected ? BrambleColors.creamBg : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x242E2B25),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: isSerif
                  ? BrambleTypography.readerSerif(
                      fontSize: 14,
                      lineHeight: 1.0,
                      color: isSelected ? BrambleColors.creamInk : BrambleColors.creamMuted,
                    ).copyWith(fontWeight: FontWeight.w700)
                  : BrambleTypography.readerSans(
                      fontSize: 14,
                      lineHeight: 1.0,
                      color: isSelected ? BrambleColors.creamInk : BrambleColors.creamMuted,
                    ).copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper({
    required String label,
    required String value,
    required VoidCallback onDec,
    required VoidCallback onInc,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: BrambleTypography.bodyMedium(
                color: BrambleColors.creamInk,
                fontWeight: FontWeight.w700,
              ).copyWith(fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: BrambleTypography.bodySmall(
                color: BrambleColors.creamMuted,
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: onDec,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: BrambleColors.creamSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Center(
                  child: Text(
                    '−',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: BrambleColors.creamInk,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onInc,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: BrambleColors.creamSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: BrambleColors.creamInk,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
