import 'package:flutter_test/flutter_test.dart';
import 'package:bramble_mobile/core/theme/bramble_theme.dart';
import 'package:bramble_mobile/features/reader/domain/reader_settings.dart';

void main() {
  group('ReaderSettings Domain Test', () {
    test('Default reader settings should match Bramble prototype specifications', () {
      const settings = ReaderSettings();
      expect(settings.themeMode, ReaderThemeMode.cream);
      expect(settings.fontSize, 19.0);
      expect(settings.lineHeight, 1.75);
      expect(settings.fontFamily, 'serif');
      expect(settings.margins, 'Regular');
      expect(settings.horizontalPadding, 22.0);
    });

    test('Margin padding calculations', () {
      const narrow = ReaderSettings(margins: 'Narrow');
      expect(narrow.horizontalPadding, 14.0);

      const wide = ReaderSettings(margins: 'Wide');
      expect(wide.horizontalPadding, 32.0);

      const regular = ReaderSettings(margins: 'Regular');
      expect(regular.horizontalPadding, 22.0);
    });

    test('Serialization and deserialization', () {
      const original = ReaderSettings(
        themeMode: ReaderThemeMode.night,
        fontSize: 22.0,
        lineHeight: 2.0,
        fontFamily: 'sans',
        margins: 'Wide',
      );

      final json = original.toJson();
      final recovered = ReaderSettings.fromJson(json);

      expect(recovered.themeMode, ReaderThemeMode.night);
      expect(recovered.fontSize, 22.0);
      expect(recovered.lineHeight, 2.0);
      expect(recovered.fontFamily, 'sans');
      expect(recovered.margins, 'Wide');
    });
  });
}
