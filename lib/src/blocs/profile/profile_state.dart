part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class GetProfileDetailsLoading extends ProfileState {}

class GetProfileDetailsSuccess extends ProfileState {}

class GetProfileDetailsError extends ProfileState {
  final error;
  GetProfileDetailsError({@required this.error});
}

class PutProfileDetailsLoading extends ProfileState {}

class PutProfileDetailsSuccess extends ProfileState {}

class PutProfileDetailsError extends ProfileState {
  final error;
  PutProfileDetailsError({@required this.error});
}
