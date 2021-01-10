import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/models/profile_details.dart';
import 'package:uniq/src/repositories/profile_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileDetails profileDetails;
  ProfileBloc({@required this.profileRepository}) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfileDetails) {
      yield GetProfileDetailsLoading();
      try {
        profileDetails = await profileRepository.getProfileDetails();
        yield GetProfileDetailsSuccess(profile: profileDetails);
      } on SocketException {
        yield GetProfileDetailsError(error: NoInternetException());
      } on HttpException {
        yield GetProfileDetailsError(error: NoServiceFoundException());
      } on FormatException {
        yield GetProfileDetailsError(error: InvalidFormatException());
      } catch (e) {
        yield GetProfileDetailsError(error: e);
      }
    }
    if (event is PutProfileDetails) {
      yield PutProfileDetailsLoading();
      try {
        await profileRepository.putProfileDetails(event.data);
        yield PutProfileDetailsSuccess();
      } on SocketException {
        yield PutProfileDetailsError(error: NoInternetException());
      } on HttpException {
        yield PutProfileDetailsError(error: NoServiceFoundException());
      } on FormatException {
        yield PutProfileDetailsError(error: InvalidFormatException());
      } catch (e) {
        yield PutProfileDetailsError(error: e);
      }
    }
  }
}
