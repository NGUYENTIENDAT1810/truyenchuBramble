class UserPreferencesModel {
  final String theme;
  final int fontSize;
  final String fontFamily;
  final double lineHeight;
  final double marginHorizontal;
  final bool autoUnlock;
  final bool soundEffects;

  const UserPreferencesModel({
    this.theme = 'cream',
    this.fontSize = 19,
    this.fontFamily = 'serif',
    this.lineHeight = 1.75,
    this.marginHorizontal = 22.0,
    this.autoUnlock = false,
    this.soundEffects = true,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'theme':
      case 'themeMode':
        return theme;
      case 'fontSize':
        return fontSize;
      case 'fontFamily':
        return fontFamily;
      case 'lineHeight':
        return lineHeight;
      case 'marginHorizontal':
        return marginHorizontal;
      case 'autoUnlock':
        return autoUnlock;
      case 'soundEffects':
        return soundEffects;
      default:
        return null;
    }
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      theme: json['theme'] ?? 'cream',
      fontSize: json['fontSize'] ?? 19,
      fontFamily: json['fontFamily'] ?? 'serif',
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.75,
      marginHorizontal: (json['marginHorizontal'] as num?)?.toDouble() ?? 22.0,
      autoUnlock: json['autoUnlock'] ?? false,
      soundEffects: json['soundEffects'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'lineHeight': lineHeight,
      'marginHorizontal': marginHorizontal,
      'autoUnlock': autoUnlock,
      'soundEffects': soundEffects,
    };
  }

  UserPreferencesModel copyWith({
    String? theme,
    int? fontSize,
    String? fontFamily,
    double? lineHeight,
    double? marginHorizontal,
    bool? autoUnlock,
    bool? soundEffects,
  }) {
    return UserPreferencesModel(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      lineHeight: lineHeight ?? this.lineHeight,
      marginHorizontal: marginHorizontal ?? this.marginHorizontal,
      autoUnlock: autoUnlock ?? this.autoUnlock,
      soundEffects: soundEffects ?? this.soundEffects,
    );
  }
}
