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
  final Map<String, dynamic> data;
  const PutProfileDetails({@required this.data});
}
