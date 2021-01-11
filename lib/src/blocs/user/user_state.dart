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
