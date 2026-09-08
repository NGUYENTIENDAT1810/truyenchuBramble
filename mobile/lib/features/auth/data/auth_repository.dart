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

    final tokens = res['tokens'];
    if (tokens != null) {
      await LocalStorage.saveToken(tokens['accessToken']);
      await LocalStorage.saveRefreshToken(tokens['refreshToken']);
    }

    final user = UserModel.fromJson(res['user']);
    await LocalStorage.saveUser(user.toJson());
    return user;
  }

  Future<UserModel> login(String email, String password) async {
    final res = await _client.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });

    final tokens = res['tokens'];
    if (tokens != null) {
      await LocalStorage.saveToken(tokens['accessToken']);
      await LocalStorage.saveRefreshToken(tokens['refreshToken']);
    }

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
}
