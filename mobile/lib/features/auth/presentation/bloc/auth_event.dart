import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthUpdatePreferencesRequested extends AuthEvent {
  final Map<String, dynamic> preferences;

  const AuthUpdatePreferencesRequested(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class AuthAddCoinsRequested extends AuthEvent {
  final int amount;

  const AuthAddCoinsRequested(this.amount);

  @override
  List<Object?> get props => [amount];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final String? name;
  final String? bio;

  const AuthUpdateProfileRequested({this.name, this.bio});

  @override
  List<Object?> get props => [name, bio];
}
