import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/local_storage.dart';
import '../../domain/settings_preferences.dart';

export '../../domain/settings_preferences.dart';

class SettingsPreferencesCubit extends Cubit<SettingsPreferences> {
  SettingsPreferencesCubit() : super(const SettingsPreferences()) {
    _loadPreferences();
  }

  void _loadPreferences() {
    final saved = LocalStorage.getSettingsPreferences();
    if (saved != null) {
      emit(SettingsPreferences.fromJson(saved));
    }
  }

  Future<void> _update(SettingsPreferences newPrefs) async {
    emit(newPrefs);
    await LocalStorage.saveSettingsPreferences(newPrefs.toJson());
  }

  void setDownloadOverWifiOnly(bool v) => _update(state.copyWith(downloadOverWifiOnly: v));
  void setNewChapterNotif(bool v) => _update(state.copyWith(newChapterNotif: v));
  void setAuthorPostsNotif(bool v) => _update(state.copyWith(authorPostsNotif: v));
  void setWeeklyDigest(bool v) => _update(state.copyWith(weeklyDigest: v));
  void setMatchSystemDarkMode(bool v) => _update(state.copyWith(matchSystemDarkMode: v));
}
