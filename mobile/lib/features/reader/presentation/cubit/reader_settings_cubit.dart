import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/theme/bramble_theme.dart';
import '../../domain/reader_settings.dart';

export '../../domain/reader_settings.dart';

class ReaderSettingsCubit extends Cubit<ReaderSettings> {
  ReaderSettingsCubit() : super(const ReaderSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final saved = LocalStorage.getReaderSettings();
    if (saved != null) {
      emit(ReaderSettings.fromJson(saved));
    }
  }

  Future<void> updateSettings(ReaderSettings newSettings) async {
    emit(newSettings);
    await LocalStorage.saveReaderSettings(newSettings.toJson());
  }

  void setTheme(ReaderThemeMode mode) => updateSettings(state.copyWith(themeMode: mode));
  void setFontSize(double size) => updateSettings(state.copyWith(fontSize: size.clamp(14, 30)));
  void setLineHeight(double lh) => updateSettings(state.copyWith(lineHeight: lh.clamp(1.2, 2.6)));
  void setFontFamily(String family) => updateSettings(state.copyWith(fontFamily: family));
  void setMargins(String margins) => updateSettings(state.copyWith(margins: margins));
  void setKeepScreenOn(bool value) => updateSettings(state.copyWith(keepScreenOn: value));
  void setHideSpoilers(bool value) => updateSettings(state.copyWith(hideSpoilers: value));
}
