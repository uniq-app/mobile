part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class ActivateLoading extends UserState {}

class ActivateSuccess extends UserState {}

class ActivateError extends UserState {
  final error;
  ActivateError({this.error});

  @override
  List<Object> get props => [error];
}

class ForgotPasswordLoading extends UserState {}

class ForgotPasswordSuccess extends UserState {}

class ForgotPasswordError extends UserState {
  final error;
  ForgotPasswordError({this.error});
}

class UpdatePasswordLoading extends UserState {}

class UpdatePasswordSuccess extends UserState {}

class UpdatePasswordError extends UserState {
  final error;
  UpdatePasswordError({this.error});
}

class ResendCodeLoading extends UserState {}

class ResendCodeSuccess extends UserState {}

class ResendCodeError extends UserState {
  final error;
  ResendCodeError({this.error});
}

class ResetPasswordLoading extends UserState {}

class ResetPasswordSuccess extends UserState {}

class ResetPasswordError extends UserState {
  final error;
  ResetPasswordError({this.error});
}

class UpdateEmailLoading extends UserState {}

class UpdateEmailSuccess extends UserState {}

class UpdateEmailError extends UserState {
  final error;
  UpdateEmailError({this.error});
}

class UpdateUsernameLoading extends UserState {}

class UpdateUsernameSuccess extends UserState {}

class UpdateUsernameError extends UserState {
  final error;
  UpdateUsernameError({this.error});
}

class ValidCodeLoading extends UserState {}

class ValidCodeSuccess extends UserState {}

class ValidCodeError extends UserState {
  final error;
  ValidCodeError({this.error});
}
