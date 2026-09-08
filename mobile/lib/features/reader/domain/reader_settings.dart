import '../../../core/theme/bramble_theme.dart';

class ReaderSettings {
  final ReaderThemeMode themeMode;
  final double fontSize;
  final double lineHeight;
  final String fontFamily; // 'serif' or 'sans'
  final String margins; // 'Narrow', 'Regular', 'Wide'
  final bool keepScreenOn;
  final bool hideSpoilers;

  const ReaderSettings({
    this.themeMode = ReaderThemeMode.cream,
    this.fontSize = 19,
    this.lineHeight = 1.75,
    this.fontFamily = 'serif',
    this.margins = 'Regular',
    this.keepScreenOn = false,
    this.hideSpoilers = true,
  });

  double get horizontalPadding {
    switch (margins) {
      case 'Narrow':
        return 14.0;
      case 'Wide':
        return 32.0;
      case 'Regular':
      default:
        return 22.0;
    }
  }

  factory ReaderSettings.fromJson(Map<String, dynamic> json) {
    ReaderThemeMode mode = ReaderThemeMode.cream;
    if (json['themeMode'] == 'sepia') mode = ReaderThemeMode.sepia;
    if (json['themeMode'] == 'night') mode = ReaderThemeMode.night;

    return ReaderSettings(
      themeMode: mode,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 19.0,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.75,
      fontFamily: json['fontFamily'] ?? 'serif',
      margins: json['margins'] ?? 'Regular',
      keepScreenOn: json['keepScreenOn'] ?? false,
      hideSpoilers: json['hideSpoilers'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'fontFamily': fontFamily,
      'margins': margins,
      'keepScreenOn': keepScreenOn,
      'hideSpoilers': hideSpoilers,
    };
  }

  ReaderSettings copyWith({
    ReaderThemeMode? themeMode,
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    String? margins,
    bool? keepScreenOn,
    bool? hideSpoilers,
  }) {
    return ReaderSettings(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      margins: margins ?? this.margins,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      hideSpoilers: hideSpoilers ?? this.hideSpoilers,
    );
  }
}
