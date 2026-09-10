class SettingsPreferences {
  final bool downloadOverWifiOnly;
  final bool newChapterNotif;
  final bool authorPostsNotif;
  final bool weeklyDigest;
  final bool matchSystemDarkMode;

  const SettingsPreferences({
    this.downloadOverWifiOnly = true,
    this.newChapterNotif = true,
    this.authorPostsNotif = true,
    this.weeklyDigest = false,
    this.matchSystemDarkMode = true,
  });

  factory SettingsPreferences.fromJson(Map<String, dynamic> json) {
    return SettingsPreferences(
      downloadOverWifiOnly: json['downloadOverWifiOnly'] ?? true,
      newChapterNotif: json['newChapterNotif'] ?? true,
      authorPostsNotif: json['authorPostsNotif'] ?? true,
      weeklyDigest: json['weeklyDigest'] ?? false,
      matchSystemDarkMode: json['matchSystemDarkMode'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'downloadOverWifiOnly': downloadOverWifiOnly,
      'newChapterNotif': newChapterNotif,
      'authorPostsNotif': authorPostsNotif,
      'weeklyDigest': weeklyDigest,
      'matchSystemDarkMode': matchSystemDarkMode,
    };
  }

  SettingsPreferences copyWith({
    bool? downloadOverWifiOnly,
    bool? newChapterNotif,
    bool? authorPostsNotif,
    bool? weeklyDigest,
    bool? matchSystemDarkMode,
  }) {
    return SettingsPreferences(
      downloadOverWifiOnly: downloadOverWifiOnly ?? this.downloadOverWifiOnly,
      newChapterNotif: newChapterNotif ?? this.newChapterNotif,
      authorPostsNotif: authorPostsNotif ?? this.authorPostsNotif,
      weeklyDigest: weeklyDigest ?? this.weeklyDigest,
      matchSystemDarkMode: matchSystemDarkMode ?? this.matchSystemDarkMode,
    );
  }
}
