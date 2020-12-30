part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Login extends AuthEvent {
  final String username;
  final String password;
  Login({@required this.username, @required this.password});

  @override
  List<Object> get props => [username, password];
}

class Logout extends AuthEvent {}
