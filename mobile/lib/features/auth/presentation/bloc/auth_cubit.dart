import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/local_storage.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';
import 'auth_state.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial());

  Future<void> checkRequested() async {
    if (state.status != AuthStatus.initializing && state is! AuthInitial) {
      return;
    }

    final token = LocalStorage.getToken();
    final refreshToken = LocalStorage.getRefreshToken();
    final savedUser = LocalStorage.getUser();

    if ((token != null || refreshToken != null) && savedUser != null) {
      try {
        final user = UserModel.fromJson(savedUser);
        emit(Authenticated(user));

        // Background sync profile
        _authRepository.getProfile().then((freshUser) {
          if (!isClosed && state is Authenticated) {
            emit(Authenticated(freshUser));
          }
        }).catchError((_) {});
      } catch (_) {
        emit(const Unauthenticated());
      }
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> loginRequested(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      emit(Authenticated(user));
    } catch (e) {
      emit(Unauthenticated(errorMessage: _mapError(e)));
    }
  }

  Future<void> registerRequested({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.register(
        email,
        password,
        name,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(Unauthenticated(errorMessage: _mapError(e)));
    }
  }

  Future<void> logoutRequested() async {
    try {
      await _authRepository.logout();
    } catch (_) {}
    emit(const Unauthenticated());
  }

  Future<void> updatePreferencesRequested(Map<String, dynamic> preferences) async {
    try {
      await _authRepository.updatePreferences(preferences);
      final current = state.user;
      if (current != null) {
        final updated = current.copyWith(
          preferences: {...?current.preferences, ...preferences},
        );
        await LocalStorage.saveUser(updated.toJson());
        emit(Authenticated(updated));
      }
    } catch (_) {}
  }

  Future<void> addCoinsRequested(int amount) async {
    final current = state.user;
    if (current == null) return;
    final updated = current.copyWith(coins: current.coins + amount);
    await LocalStorage.saveUser(updated.toJson());
    emit(Authenticated(updated));
  }

  Future<void> updateProfileRequested({String? name, String? bio}) async {
    final current = state.user;
    if (current == null) return;
    final updated = current.copyWith(name: name, bio: bio);
    await LocalStorage.saveUser(updated.toJson());
    emit(Authenticated(updated));
  }

  String _mapError(dynamic e) {
    final str = e.toString();
    if (str.contains('SocketException') || str.contains('Connection refused') || str.contains('Failed host lookup')) {
      return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại mạng.';
    }
    if (str.contains('401') || str.contains('Bad credentials') || str.contains('Invalid email or password')) {
      return 'Email hoặc mật khẩu không chính xác.';
    }
    if (str.contains('409') || str.contains('already exists') || str.contains('Email already')) {
      return 'Email này đã được đăng ký tài khoản.';
    }
    return str.replaceAll('Exception: ', '');
  }
}
