import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bramble_mobile/core/storage/local_storage.dart';
import 'package:bramble_mobile/features/auth/data/auth_repository.dart';
import 'package:bramble_mobile/features/auth/domain/user_model.dart';
import 'package:bramble_mobile/features/auth/presentation/bloc/auth_bloc.dart';

class FakeAuthRepository implements AuthRepository {
  UserModel? mockUser;
  bool shouldThrow = false;

  @override
  Future<UserModel> login(String email, String password) async {
    if (shouldThrow) throw Exception('Invalid credentials');
    return mockUser ?? UserModel(id: '1', email: email, name: 'Test User');
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    if (shouldThrow) throw Exception('Registration failed');
    return UserModel(id: '2', email: email, name: name);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel> getProfile() async {
    return mockUser ?? const UserModel(id: '1', email: 'test@bramble.com', name: 'Test User');
  }

  @override
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthBloc', () {
    late FakeAuthRepository authRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalStorage.init();
      authRepository = FakeAuthRepository();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when AuthCheckRequested has no stored session',
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [const Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when AuthLoginRequested succeeds',
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => bloc.add(const AuthLoginRequested(email: 'test@example.com', password: 'password')),
      expect: () => [
        const AuthLoading(),
        isA<Authenticated>().having((s) => s.user?.email, 'email', 'test@example.com'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when AuthLoginRequested fails',
      build: () {
        authRepository.shouldThrow = true;
        return AuthBloc(authRepository: authRepository);
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(email: 'wrong@example.com', password: 'bad')),
      expect: () => [
        const AuthLoading(),
        isA<Unauthenticated>().having((s) => s.errorMessage, 'error message', isNotNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when AuthLogoutRequested is called',
      build: () => AuthBloc(authRepository: authRepository),
      seed: () => const Authenticated(UserModel(id: '1', email: 'test@bramble.com', name: 'Test User')),
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [const Unauthenticated()],
    );
  });
}
