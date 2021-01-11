import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/repositories/user_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({this.userRepository}) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is Activate) {
      yield ActivateLoading();
      try {
        await userRepository.activate(event.code);
        yield ActivateSuccess();
      } on SocketException {
        yield ActivateError(error: NoInternetException());
      } on HttpException {
        yield ActivateError(error: NoServiceFoundException());
      } on FormatException {
        yield ActivateError(error: InvalidFormatException());
      } catch (e) {
        yield ActivateError(error: e);
      }
    }
    if (event is ForgotPassword) {
      yield ForgotPasswordLoading();
      try {
        await userRepository.forgotPassword(event.email);
        yield ForgotPasswordSuccess();
      } on SocketException {
        yield ForgotPasswordError(error: NoInternetException());
      } on HttpException {
        yield ForgotPasswordError(error: NoServiceFoundException());
      } on FormatException {
        yield ForgotPasswordError(error: InvalidFormatException());
      } catch (e) {
        yield ForgotPasswordError(error: e);
      }
    }
    if (event is UpdatePassword) {
      yield UpdatePasswordLoading();
      try {
        await userRepository.updatePassword(
            event.newPassword, event.oldPassword, event.newPassword);
        yield UpdatePasswordSuccess();
      } on SocketException {
        yield UpdatePasswordError(error: NoInternetException());
      } on HttpException {
        yield UpdatePasswordError(error: NoServiceFoundException());
      } on FormatException {
        yield UpdatePasswordError(error: InvalidFormatException());
      } catch (e) {
        yield UpdatePasswordError(error: e);
      }
    }

    if (event is ClearState) {
      yield UserInitial();
    }
  }
}
