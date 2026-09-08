import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bramble_colors.dart';

enum ReaderThemeMode {
  cream,
  sepia,
  night,
}

class ReaderThemeConfig {
  final Color bg;
  final Color ink;
  final Color surface;
  final Color chrome;
  final Color muted;
  final bool isDark;

  const ReaderThemeConfig({
    required this.bg,
    required this.ink,
    required this.surface,
    required this.chrome,
    required this.muted,
    required this.isDark,
  });

  static const cream = ReaderThemeConfig(
    bg: BrambleColors.creamBg,
    ink: BrambleColors.creamInk,
    surface: BrambleColors.creamSurface,
    chrome: Color(0xDCF5EAD8),
    muted: BrambleColors.creamMuted,
    isDark: false,
  );

  static const sepia = ReaderThemeConfig(
    bg: BrambleColors.sepiaBg,
    ink: BrambleColors.sepiaInk,
    surface: BrambleColors.sepiaSurface,
    chrome: Color(0xDCE8D7B4),
    muted: BrambleColors.sepiaMuted,
    isDark: false,
  );

  static const night = ReaderThemeConfig(
    bg: BrambleColors.nightBg,
    ink: BrambleColors.nightInk,
    surface: BrambleColors.nightSurface,
    chrome: Color(0xDC211F1C),
    muted: BrambleColors.nightMuted,
    isDark: true,
  );

  static ReaderThemeConfig fromMode(ReaderThemeMode mode) {
    switch (mode) {
      case ReaderThemeMode.sepia:
        return sepia;
      case ReaderThemeMode.night:
        return night;
      case ReaderThemeMode.cream:
        return cream;
    }
  }
}

class BrambleTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: BrambleColors.creamBg,
      primaryColor: BrambleColors.primaryOrange,
      colorScheme: const ColorScheme.light(
        primary: BrambleColors.primaryOrange,
        surface: BrambleColors.creamSurface,
        onSurface: BrambleColors.creamInk,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: BrambleColors.creamBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
