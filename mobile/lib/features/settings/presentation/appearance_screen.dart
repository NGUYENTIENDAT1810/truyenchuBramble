import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_theme.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../reader/presentation/reader_controller.dart';

class AppearanceScreen extends ConsumerStatefulWidget {
  const AppearanceScreen({super.key});

  @override
  ConsumerState<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends ConsumerState<AppearanceScreen> {
  bool _matchSystem = true;
  bool _keepScreen = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final notifier = ref.read(readerSettingsProvider.notifier);
    final themeConfig = ReaderThemeConfig.fromMode(settings.themeMode);

    final marginOptions = ['Narrow', 'Regular', 'Wide'];

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: BrambleColors.creamBg,
                  border: Border(
                    bottom: BorderSide(
                      color: BrambleColors.creamInk.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: BrambleColors.creamInk.withOpacity(0.06),
                        ),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: BrambleColors.creamInk,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Font & theme',
                      style: BrambleTypography.displaySmall(
                        color: BrambleColors.creamInk,
                      ).copyWith(fontSize: 19),
                    ),
                  ],
                ),
              ),

              // Live Preview Card
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeConfig.bg,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x242E2B25),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREVIEW',
                        style: BrambleTypography.labelUppercase(
                          color: themeConfig.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'She read the entry twice. A brig called the Orrery, three tons of unspecified cargo, and in the correction column a single word that was not a number at all.',
                        style: settings.fontFamily == 'serif'
                            ? BrambleTypography.readerSerif(
                                fontSize: settings.fontSize,
                                lineHeight: settings.lineHeight,
                                color: themeConfig.ink,
                              )
                            : BrambleTypography.readerSans(
                                fontSize: settings.fontSize,
                                lineHeight: settings.lineHeight,
                                color: themeConfig.ink,
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Section: Theme
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THEME',
                      style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
                    ),
                    const SizedBox(height: 11),
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
                  ],
                ),
              ),

              // Section: Typeface
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TYPEFACE',
                      style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
                    ),
                    const SizedBox(height: 11),
                    _buildFaceCard(
                      id: 'serif',
                      title: 'The Ledger of Tides',
                      note: 'Lora · a warm book serif',
                      isSerif: true,
                      isSelected: settings.fontFamily == 'serif',
                      onTap: () => notifier.setFontFamily('serif'),
                    ),
                    const SizedBox(height: 9),
                    _buildFaceCard(
                      id: 'sans',
                      title: 'The Ledger of Tides',
                      note: 'Figtree · the interface face',
                      isSerif: false,
                      isSelected: settings.fontFamily == 'sans',
                      onTap: () => notifier.setFontFamily('sans'),
                    ),
                  ],
                ),
              ),

              // Section: Size & Rhythm
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIZE & RHYTHM',
                      style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
                    ),
                    const SizedBox(height: 14),
                    _buildStepper(
                      label: 'Text size',
                      value: '${settings.fontSize.toInt()}px',
                      onDec: () => notifier.setFontSize(settings.fontSize - 1),
                      onInc: () => notifier.setFontSize(settings.fontSize + 1),
                    ),
                    const SizedBox(height: 14),
                    _buildStepper(
                      label: 'Line spacing',
                      value: settings.lineHeight.toStringAsFixed(2),
                      onDec: () => notifier.setLineHeight(settings.lineHeight - 0.15),
                      onInc: () => notifier.setLineHeight(settings.lineHeight + 0.15),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Margins',
                      style: BrambleTypography.bodyMedium(
                        color: BrambleColors.creamInk,
                        fontWeight: FontWeight.w700,
                      ).copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      height: 42,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: marginOptions.map((opt) {
                          final isSelected = settings.margins == opt;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => notifier.setMargins(opt),
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
                                    opt,
                                    style: BrambleTypography.bodySmall(
                                      color: isSelected ? BrambleColors.creamInk : BrambleColors.creamMuted,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(fontSize: 13.5),
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
              ),

              // Section: Appearance Toggles
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                child: Column(
                  children: [
                    _buildToggleRow(
                      label: 'Match system dark mode',
                      note: 'Switch to Night when the phone does',
                      value: _matchSystem,
                      onChanged: (v) => setState(() => _matchSystem = v),
                    ),
                    _buildToggleRow(
                      label: 'Keep screen on',
                      note: 'While a chapter is open',
                      value: _keepScreen,
                      onChanged: (v) => setState(() => _keepScreen = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildFaceCard({
    required String id,
    required String title,
    required String note,
    required bool isSerif,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? BrambleColors.peachSelection : BrambleColors.creamSurface,
          borderRadius: BorderRadius.circular(22),
          border: isSelected ? Border.all(color: BrambleColors.primaryOrange, width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: isSerif
                  ? BrambleTypography.readerSerif(
                      fontSize: 19,
                      lineHeight: 1.3,
                      color: BrambleColors.creamInk,
                    )
                  : BrambleTypography.readerSans(
                      fontSize: 19,
                      lineHeight: 1.3,
                      color: BrambleColors.creamInk,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              note,
              style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted),
            ),
          ],
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

  Widget _buildToggleRow({
    required String label,
    required String note,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BrambleColors.creamInk.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: BrambleTypography.bodyMedium(
                    color: BrambleColors.creamInk,
                    fontWeight: FontWeight.w600,
                  ).copyWith(fontSize: 15),
                ),
                const SizedBox(height: 3),
                Text(
                  note,
                  style: BrambleTypography.bodySmall(
                    color: BrambleColors.creamMuted,
                  ).copyWith(fontSize: 12.5),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 52,
              height: 31,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: value ? BrambleColors.primaryOrange : BrambleColors.creamDivider,
              ),
              child: Align(
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF9F4ED),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x242E2B25),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
