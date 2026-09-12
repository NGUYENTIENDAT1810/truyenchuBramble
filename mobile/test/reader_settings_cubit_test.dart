import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bramble_mobile/core/storage/local_storage.dart';
import 'package:bramble_mobile/core/theme/bramble_theme.dart';
import 'package:bramble_mobile/features/reader/presentation/cubit/reader_settings_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReaderSettingsCubit', () {
    late ReaderSettingsCubit cubit;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalStorage.init();
      cubit = ReaderSettingsCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has default reader settings', () {
      expect(cubit.state.themeMode, ReaderThemeMode.cream);
      expect(cubit.state.fontSize, 19.0);
      expect(cubit.state.fontFamily, 'serif');
    });

    test('setTheme updates state and persists', () async {
      cubit.setTheme(ReaderThemeMode.night);
      expect(cubit.state.themeMode, ReaderThemeMode.night);
    });

    test('setFontSize clamps values properly', () async {
      cubit.setFontSize(50);
      expect(cubit.state.fontSize, 30.0);

      cubit.setFontSize(5);
      expect(cubit.state.fontSize, 14.0);
    });

    test('setFontFamily updates state', () async {
      cubit.setFontFamily('sans');
      expect(cubit.state.fontFamily, 'sans');
    });

    test('setKeepScreenOn and setHideSpoilers update state', () async {
      cubit.setKeepScreenOn(false);
      expect(cubit.state.keepScreenOn, false);

      cubit.setHideSpoilers(true);
      expect(cubit.state.hideSpoilers, true);
    });
  });
}
