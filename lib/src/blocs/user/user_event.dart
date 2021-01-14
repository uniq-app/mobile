part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class Activate extends UserEvent {
  final String code;
  Activate({@required this.code});

  @override
  List<Object> get props => [code];
}

class GetCode extends UserEvent {}

class ForgotPassword extends UserEvent {
  final String email;
  ForgotPassword({@required this.email});

  @override
  List<Object> get props => [email];
}

class UpdatePassword extends UserEvent {
  final String oldPassword;
  final String newPassword;
  UpdatePassword({@required this.oldPassword, @required this.newPassword});

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class ResendCode extends UserEvent {
  final String email;
  ResendCode({@required this.email});
}

class ResetPassword extends UserEvent {
  final String email;
  final String password;
  ResetPassword({@required this.email, @required this.password});
}

class UpdateEmail extends UserEvent {
  final String email;
  UpdateEmail({@required this.email});
}

class UpdateUsername extends UserEvent {
  final String username;
  UpdateUsername({@required this.username});
}

class ValidCode extends UserEvent {
  final String code;
  ValidCode({@required this.code});
}

class ClearState extends UserEvent {
  @override
  List<Object> get props => [];
}
