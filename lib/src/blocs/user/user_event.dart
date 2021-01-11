part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

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
