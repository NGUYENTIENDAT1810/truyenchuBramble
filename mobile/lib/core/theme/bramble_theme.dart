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
  final Color surfaceElevated;
  final Color chrome;
  final Color muted;
  final Color divider;
  final bool isDark;

  const ReaderThemeConfig({
    required this.bg,
    required this.ink,
    required this.surface,
    required this.surfaceElevated,
    required this.chrome,
    required this.muted,
    required this.divider,
    required this.isDark,
  });

  static const cream = ReaderThemeConfig(
    bg: BrambleColors.creamBg,
    ink: BrambleColors.creamInk,
    surface: BrambleColors.creamSurface,
    surfaceElevated: BrambleColors.creamSurfaceElevated,
    chrome: Color(0xECF5EAD8),
    muted: BrambleColors.creamMuted,
    divider: BrambleColors.creamDivider,
    isDark: false,
  );

  static const sepia = ReaderThemeConfig(
    bg: BrambleColors.sepiaBg,
    ink: BrambleColors.sepiaInk,
    surface: BrambleColors.sepiaSurface,
    surfaceElevated: BrambleColors.sepiaSurfaceElevated,
    chrome: Color(0xECE8D7B4),
    muted: BrambleColors.sepiaMuted,
    divider: BrambleColors.sepiaDivider,
    isDark: false,
  );

  static const night = ReaderThemeConfig(
    bg: BrambleColors.nightBg,
    ink: BrambleColors.nightInk,
    surface: BrambleColors.nightSurface,
    surfaceElevated: BrambleColors.nightSurfaceElevated,
    chrome: Color(0xEC1B1917),
    muted: BrambleColors.nightMuted,
    divider: BrambleColors.nightDivider,
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
        error: BrambleColors.error,
      ),
      dividerColor: BrambleColors.creamDivider,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: BrambleColors.creamBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: BrambleColors.creamBg,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
    );
  }
}
