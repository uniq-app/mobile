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

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  RegisterSuccess();

  @override
  List<Object> get props => [];
}

class RegisterError extends AuthState {
  final error;
  RegisterError({this.error});

  @override
  List<Object> get props => [error];
}

class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}

class ActivateLoading extends AuthState {}

class ActivateSuccess extends AuthState {}

class ActivateError extends AuthState {
  final error;
  ActivateError({this.error});

  @override
  List<Object> get props => [error];
}
