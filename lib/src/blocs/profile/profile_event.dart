part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileDetails extends ProfileEvent {
  const GetProfileDetails();
}

class PutProfileDetails extends ProfileEvent {
  // TODO: Implement argument
  const PutProfileDetails();
}
