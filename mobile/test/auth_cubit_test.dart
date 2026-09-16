import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bramble_mobile/core/storage/local_storage.dart';
import 'package:bramble_mobile/features/auth/data/auth_repository.dart';
import 'package:bramble_mobile/features/auth/domain/user_model.dart';
import 'package:bramble_mobile/features/auth/presentation/bloc/auth_cubit.dart';

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

  group('AuthCubit', () {
    late FakeAuthRepository authRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalStorage.init();
      authRepository = FakeAuthRepository();
    });

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when checkRequested has no stored session',
      build: () => AuthCubit(authRepository: authRepository),
      act: (cubit) => cubit.checkRequested(),
      expect: () => [const Unauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] when loginRequested succeeds',
      build: () => AuthCubit(authRepository: authRepository),
      act: (cubit) => cubit.loginRequested('test@example.com', 'password'),
      expect: () => [
        const AuthLoading(),
        isA<Authenticated>().having((s) => s.user?.email, 'email', 'test@example.com'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] when loginRequested fails',
      build: () {
        authRepository.shouldThrow = true;
        return AuthCubit(authRepository: authRepository);
      },
      act: (cubit) => cubit.loginRequested('wrong@example.com', 'bad'),
      expect: () => [
        const AuthLoading(),
        isA<Unauthenticated>().having((s) => s.errorMessage, 'error message', isNotNull),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when logoutRequested is called',
      build: () => AuthCubit(authRepository: authRepository),
      seed: () => const Authenticated(UserModel(id: '1', email: 'test@bramble.com', name: 'Test User')),
      act: (cubit) => cubit.logoutRequested(),
      expect: () => [const Unauthenticated()],
    );
  });
}
