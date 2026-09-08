import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/theme/bramble_theme.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/reader_repository.dart';
import '../domain/reader_settings.dart';

final readerRepositoryProvider = Provider<ReaderRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ReaderRepository(client);
});

// Reader Settings StateNotifier
class ReaderSettingsNotifier extends StateNotifier<ReaderSettings> {
  ReaderSettingsNotifier() : super(const ReaderSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final saved = LocalStorage.getReaderSettings();
    if (saved != null) {
      state = ReaderSettings.fromJson(saved);
    }
  }

  Future<void> updateSettings(ReaderSettings newSettings) async {
    state = newSettings;
    await LocalStorage.saveReaderSettings(newSettings.toJson());
  }

  void setTheme(ReaderThemeMode mode) => updateSettings(state.copyWith(themeMode: mode));
  void setFontSize(double size) => updateSettings(state.copyWith(fontSize: size.clamp(14, 30)));
  void setLineHeight(double lh) => updateSettings(state.copyWith(lineHeight: lh.clamp(1.2, 2.6)));
  void setFontFamily(String family) => updateSettings(state.copyWith(fontFamily: family));
  void setMargins(String margins) => updateSettings(state.copyWith(margins: margins));
}

final readerSettingsProvider =
    StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((ref) {
  return ReaderSettingsNotifier();
});

final chapterContentProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, chapterId) async {
  final repo = ref.watch(readerRepositoryProvider);
  return repo.getChapterContent(chapterId);
});
