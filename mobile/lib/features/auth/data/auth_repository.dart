import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../domain/user_model.dart';

class AuthRepository {
  final ApiClient _client;

  AuthRepository(this._client);

  Future<UserModel> register(String email, String password, String name) async {
    final res = await _client.post(ApiEndpoints.register, data: {
      'email': email,
      'password': password,
      'name': name,
    });

    await _storeAuthTokens(res);

    final user = UserModel.fromJson(res['user']);
    await LocalStorage.saveUser(user.toJson());
    return user;
  }

  Future<UserModel> login(String email, String password) async {
    final res = await _client.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });

    await _storeAuthTokens(res);

    final user = UserModel.fromJson(res['user']);
    await LocalStorage.saveUser(user.toJson());
    return user;
  }

  Future<UserModel> getProfile() async {
    final res = await _client.get(ApiEndpoints.profile);
    final user = UserModel.fromJson(res);
    await LocalStorage.saveUser(user.toJson());
    return user;
  }

  Future<void> updatePreferences(Map<String, dynamic> prefs) async {
    await _client.put(ApiEndpoints.updatePreferences, data: prefs);
  }

  Future<void> logout() async {
    try {
      final rt = LocalStorage.getRefreshToken();
      await _client.post(ApiEndpoints.logout, data: {'refreshToken': rt});
    } catch (_) {}
    await LocalStorage.clearAuth();
  }

  Future<void> _storeAuthTokens(Map<String, dynamic> response) async {
    final tokens = response['tokens'] is Map<String, dynamic>
        ? response['tokens'] as Map<String, dynamic>
        : response;
    final accessToken = tokens['accessToken'] as String?;
    final refreshToken = tokens['refreshToken'] as String?;

    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Login response did not contain an access token');
    }

    await LocalStorage.saveToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await LocalStorage.saveRefreshToken(refreshToken);
    }
  }
}
