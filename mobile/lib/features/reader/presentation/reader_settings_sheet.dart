import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_theme.dart';
import '../../../core/theme/bramble_typography.dart';
import 'cubit/reader_settings_cubit.dart';

class ReaderSettingsSheet extends StatelessWidget {
  const ReaderSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReaderSettingsCubit, ReaderSettings>(
      builder: (context, settings) {
        final cubit = context.read<ReaderSettingsCubit>();

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
                style: BrambleTypography.labelUppercase(
                    color: BrambleColors.creamMuted),
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
                    onTap: () => cubit.setTheme(ReaderThemeMode.cream),
                  ),
                  const SizedBox(width: 10),
                  _buildThemeCard(
                    label: 'Sepia',
                    mode: ReaderThemeMode.sepia,
                    bg: const Color(0xFFE8D7B4),
                    ink: const Color(0xFF3A2C17),
                    isSelected: settings.themeMode == ReaderThemeMode.sepia,
                    onTap: () => cubit.setTheme(ReaderThemeMode.sepia),
                  ),
                  const SizedBox(width: 10),
                  _buildThemeCard(
                    label: 'Night',
                    mode: ReaderThemeMode.night,
                    bg: const Color(0xFF211F1C),
                    ink: const Color(0xFFE7DFD1),
                    isSelected: settings.themeMode == ReaderThemeMode.night,
                    onTap: () => cubit.setTheme(ReaderThemeMode.night),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Typeface
              Text(
                'TYPEFACE',
                style: BrambleTypography.labelUppercase(
                    color: BrambleColors.creamMuted),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTypefaceButton(
                      label: 'Lora',
                      fontFamily: 'serif',
                      isSelected: settings.fontFamily == 'serif',
                      onTap: () => cubit.setFontFamily('serif'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTypefaceButton(
                      label: 'Figtree',
                      fontFamily: 'sans',
                      isSelected: settings.fontFamily == 'sans',
                      onTap: () => cubit.setFontFamily('sans'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Font Size Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SIZE',
                    style: BrambleTypography.labelUppercase(
                        color: BrambleColors.creamMuted),
                  ),
                  Text(
                    '${settings.fontSize.toInt()} px',
                    style: BrambleTypography.caption(
                      color: BrambleColors.creamInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'A',
                    style: BrambleTypography.bodySmall(
                        color: BrambleColors.creamMuted),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: BrambleColors.primaryOrange,
                        inactiveTrackColor: BrambleColors.creamDivider,
                        thumbColor: BrambleColors.primaryOrange,
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: settings.fontSize,
                        min: 14,
                        max: 28,
                        divisions: 14,
                        onChanged: (val) => cubit.setFontSize(val),
                      ),
                    ),
                  ),
                  Text(
                    'A',
                    style: BrambleTypography.titleLarge(
                        color: BrambleColors.creamInk),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Line Height
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LINE HEIGHT',
                    style: BrambleTypography.labelUppercase(
                        color: BrambleColors.creamMuted),
                  ),
                  Text(
                    settings.lineHeight.toStringAsFixed(2),
                    style: BrambleTypography.caption(
                      color: BrambleColors.creamInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: BrambleColors.primaryOrange,
                  inactiveTrackColor: BrambleColors.creamDivider,
                  thumbColor: BrambleColors.primaryOrange,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: settings.lineHeight,
                  min: 1.2,
                  max: 2.4,
                  divisions: 11,
                  onChanged: (val) => cubit.setLineHeight(val),
                ),
              ),
              const SizedBox(height: 14),

              // Margins
              Text(
                'MARGINS',
                style: BrambleTypography.labelUppercase(
                    color: BrambleColors.creamMuted),
              ),
              const SizedBox(height: 10),
              Container(
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: BrambleColors.creamSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: ['Narrow', 'Regular', 'Wide'].map((m) {
                    final isSel = settings.margins == m;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => cubit.setMargins(m),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isSel
                                ? BrambleColors.creamBg
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: isSel
                                ? const [
                                    BoxShadow(
                                        color: Color(0x1F2E2B25),
                                        blurRadius: 2,
                                        offset: Offset(0, 1))
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              m,
                              style: BrambleTypography.bodySmall(
                                color: isSel
                                    ? BrambleColors.creamInk
                                    : BrambleColors.creamMuted,
                                fontWeight:
                                    isSel ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 80,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? BrambleColors.primaryOrange
                  : BrambleColors.creamBorder.withOpacity(0.5),
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aa',
                style: TextStyle(
                  color: ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif',
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: ink.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypefaceButton({
    required String label,
    required String fontFamily,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? BrambleColors.peachSelection
              : BrambleColors.creamSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? BrambleColors.primaryOrange
                : BrambleColors.creamBorder.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: fontFamily == 'serif' ? 'Lora' : 'Figtree',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? BrambleColors.primaryOrangeDark
                  : BrambleColors.creamInk,
            ),
          ),
        ),
      ),
    );
  }
}
