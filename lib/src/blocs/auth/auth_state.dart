part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String token;
  LoginSuccess({@required this.token});

  @override
  List<Object> get props => [token];
}

class LoginError extends AuthState {
  final error;
  LoginError({this.error});

  @override
  List<Object> get props => [error];
}

class SignupLoading extends AuthState {}

class SignupSuccess extends AuthState {
  final String token;
  SignupSuccess({@required this.token});

  @override
  List<Object> get props => [token];
}

class SignupError extends AuthState {
  final error;
  SignupError({this.error});

  @override
  List<Object> get props => [error];
}

class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}
