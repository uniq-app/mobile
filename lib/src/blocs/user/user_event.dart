part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class ResetPassword extends UserEvent {
  final String username;
  final String email;
  ResetPassword({@required this.email, @required this.username});

  @override
  List<Object> get props => [username, email];
}

class NewPassword extends UserEvent {
  final String safetyCode;
  final String password;
  NewPassword({@required this.safetyCode, @required this.password});

  @override
  List<Object> get props => [safetyCode, password];
}

class Activate extends UserEvent {
  final String code;
  Activate({@required this.code});

  @override
  List<Object> get props => [code];
}

class ClearState extends UserEvent {
  @override
  List<Object> get props => [];
}
