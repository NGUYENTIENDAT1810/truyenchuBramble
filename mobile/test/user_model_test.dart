import 'package:flutter_test/flutter_test.dart';
import 'package:bramble_mobile/features/auth/domain/user_model.dart';

void main() {
  group('UserModel Domain Test', () {
    test('JSON serialization & deserialization', () {
      const user = UserModel(
        id: 'user-123',
        email: 'noor@example.com',
        name: 'Noor Rahim',
        role: 'USER',
        coins: 120,
        isPremium: true,
      );

      final json = user.toJson();
      final fromJson = UserModel.fromJson(json);

      expect(fromJson.id, 'user-123');
      expect(fromJson.email, 'noor@example.com');
      expect(fromJson.name, 'Noor Rahim');
      expect(fromJson.coins, 120);
      expect(fromJson.isPremium, true);
    });

    test('CopyWith updates properties correctly', () {
      const user = UserModel(
        id: 'user-1',
        email: 'test@bramble.com',
        name: 'Test',
        role: 'USER',
      );

      final updated = user.copyWith(coins: 200, isPremium: true);
      expect(updated.coins, 200);
      expect(updated.isPremium, true);
      expect(updated.name, 'Test');
    });
  });
}
