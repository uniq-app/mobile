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

class Activate extends AuthEvent {
  final String code;
  Activate({@required this.code});

  @override
  List<Object> get props => [code];
}

class Register extends AuthEvent {
  final String username;
  final String password;
  final String email;
  Register(
      {@required this.email, @required this.password, @required this.username});

  @override
  List<Object> get props => [username, email, password];
}

class ResetPassword extends AuthEvent {
  final String username;
  final String email;
  ResetPassword({@required this.email, @required this.username});

  @override
  List<Object> get props => [username, email];
}

class NewPassword extends AuthEvent {
  final String safetyCode;
  final String password;
  NewPassword({@required this.safetyCode, @required this.password});

  @override
  List<Object> get props => [safetyCode, password];
}

class Logout extends AuthEvent {}
