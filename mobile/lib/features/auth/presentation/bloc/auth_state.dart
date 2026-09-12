import 'package:equatable/equatable.dart';
import '../../domain/user_model.dart';

enum AuthStatus {
  initializing,
  authenticated,
  unauthenticated,
  loading,
}

abstract class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, user, errorMessage];
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(status: AuthStatus.initializing);
}

class AuthLoading extends AuthState {
  const AuthLoading({UserModel? currentUser})
      : super(status: AuthStatus.loading, user: currentUser);
}

class Authenticated extends AuthState {
  const Authenticated(UserModel user)
      : super(status: AuthStatus.authenticated, user: user);
}

class Unauthenticated extends AuthState {
  const Unauthenticated({super.errorMessage})
      : super(status: AuthStatus.unauthenticated);
}
