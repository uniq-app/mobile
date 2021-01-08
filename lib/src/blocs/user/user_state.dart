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
