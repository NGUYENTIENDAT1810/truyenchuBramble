import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage.dart';
import '../domain/settings_preferences.dart';

class SettingsPreferencesNotifier extends StateNotifier<SettingsPreferences> {
  SettingsPreferencesNotifier() : super(const SettingsPreferences()) {
    _loadPreferences();
  }

  void _loadPreferences() {
    final saved = LocalStorage.getSettingsPreferences();
    if (saved != null) {
      state = SettingsPreferences.fromJson(saved);
    }
  }

  Future<void> _update(SettingsPreferences newPrefs) async {
    state = newPrefs;
    await LocalStorage.saveSettingsPreferences(newPrefs.toJson());
  }

  void setDownloadOverWifiOnly(bool v) => _update(state.copyWith(downloadOverWifiOnly: v));
  void setNewChapterNotif(bool v) => _update(state.copyWith(newChapterNotif: v));
  void setAuthorPostsNotif(bool v) => _update(state.copyWith(authorPostsNotif: v));
  void setWeeklyDigest(bool v) => _update(state.copyWith(weeklyDigest: v));
  void setMatchSystemDarkMode(bool v) => _update(state.copyWith(matchSystemDarkMode: v));
}

final settingsPreferencesProvider =
    StateNotifierProvider<SettingsPreferencesNotifier, SettingsPreferences>((ref) {
  return SettingsPreferencesNotifier();
});
