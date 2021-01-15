part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  @override
  List<Object> get props => [];
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
