import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/repositories/profile_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc({@required this.profileRepository}) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfileDetails) {
      yield GetProfileDetailsLoading();
      try {
        await profileRepository.getProfileDetails();
        yield GetProfileDetailsSuccess();
      } on SocketException {
        yield GetProfileDetailsError(error: NoInternetException('No internet'));
      } on HttpException {
        yield GetProfileDetailsError(
            error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield GetProfileDetailsError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield GetProfileDetailsError(
            error: NoInternetException('Unknown error'));
      }
    }
    if (event is PutProfileDetails) {
      yield PutProfileDetailsLoading();
      try {
        await profileRepository.putProfileDetails();
        yield PutProfileDetailsSuccess();
      } on SocketException {
        yield PutProfileDetailsError(error: NoInternetException('No internet'));
      } on HttpException {
        yield PutProfileDetailsError(
            error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield PutProfileDetailsError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield PutProfileDetailsError(
            error: NoInternetException('Unknown error'));
      }
    }
  }
}
