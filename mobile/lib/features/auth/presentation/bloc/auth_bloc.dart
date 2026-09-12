import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/local_storage.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUpdatePreferencesRequested>(_onUpdatePreferencesRequested);
    on<AuthAddCoinsRequested>(_onAddCoinsRequested);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
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

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(Unauthenticated(errorMessage: _mapError(e)));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.register(
        event.email,
        event.password,
        event.name,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(Unauthenticated(errorMessage: _mapError(e)));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logout();
    } catch (_) {}
    emit(const Unauthenticated());
  }

  Future<void> _onUpdatePreferencesRequested(
    AuthUpdatePreferencesRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.updatePreferences(event.preferences);
      final current = state.user;
      if (current != null) {
        final updated = current.copyWith(
          preferences: {...?current.preferences, ...event.preferences},
        );
        await LocalStorage.saveUser(updated.toJson());
        emit(Authenticated(updated));
      }
    } catch (_) {}
  }

  Future<void> _onAddCoinsRequested(
    AuthAddCoinsRequested event,
    Emitter<AuthState> emit,
  ) async {
    final current = state.user;
    if (current == null) return;
    final updated = current.copyWith(coins: current.coins + event.amount);
    await LocalStorage.saveUser(updated.toJson());
    emit(Authenticated(updated));
  }

  Future<void> _onUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    final current = state.user;
    if (current == null) return;
    final updated = current.copyWith(name: event.name, bio: event.bio);
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
