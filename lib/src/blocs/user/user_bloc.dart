import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/blocs/notification/notification_bloc.dart';
import 'package:uniq/src/repositories/user_repository.dart';
import 'package:uniq/src/services/auth_api_provider.dart';
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
    if (event is GetCode) {
      yield GetCodeLoading();
      try {
        await userRepository.getCode();
        yield GetCodeSuccess();
      } on SocketException {
        yield GetCodeError(error: NoInternetException());
      } on HttpException {
        yield GetCodeError(error: NoServiceFoundException());
      } on FormatException {
        yield GetCodeError(error: InvalidFormatException());
      } catch (e) {
        yield GetCodeError(error: e);
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
            event.oldPassword, event.newPassword, event.newPassword);
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
    if (event is ResendCode) {
      yield ResendCodeLoading();
      try {
        await userRepository.resendCode(event.email);
        yield ResendCodeSuccess();
      } on SocketException {
        yield ResendCodeError(error: NoInternetException());
      } on HttpException {
        yield ResendCodeError(error: NoServiceFoundException());
      } on FormatException {
        yield ResendCodeError(error: InvalidFormatException());
      } catch (e) {
        yield ResendCodeError(error: e);
      }
    }
    if (event is ResetPassword) {
      yield ResetPasswordLoading();
      try {
        await userRepository.resetPassword(event.email, event.password);
        yield ResetPasswordSuccess();
      } on SocketException {
        yield ResetPasswordError(error: NoInternetException());
      } on HttpException {
        yield ResetPasswordError(error: NoServiceFoundException());
      } on FormatException {
        yield ResetPasswordError(error: InvalidFormatException());
      } catch (e) {
        yield ResetPasswordError(error: e);
      }
    }
    if (event is UpdateEmail) {
      yield UpdateEmailLoading();
      try {
        await userRepository.updateEmail(event.email);
        yield UpdateEmailSuccess();
      } on SocketException {
        yield UpdateEmailError(error: NoInternetException());
      } on HttpException {
        yield UpdateEmailError(error: NoServiceFoundException());
      } on FormatException {
        yield UpdateEmailError(error: InvalidFormatException());
      } catch (e) {
        yield UpdateEmailError(error: e);
      }
    }
    if (event is UpdateUsername) {
      yield UpdateUsernameLoading();
      try {
        var body = await userRepository.updateUsername(event.username);
        String newJwt = body['jwt'];
        AuthApiProvider.storeToken(newJwt);
        yield UpdateUsernameSuccess();
      } on SocketException {
        yield UpdateUsernameError(error: NoInternetException());
      } on HttpException {
        yield UpdateUsernameError(error: NoServiceFoundException());
      } on FormatException {
        yield UpdateUsernameError(error: InvalidFormatException());
      } catch (e) {
        yield UpdateUsernameError(error: e);
      }
    }
    if (event is ValidCode) {
      yield ValidCodeLoading();
      try {
        await userRepository.validCode(event.code);
        yield ValidCodeSuccess();
      } on SocketException {
        yield ValidCodeError(error: NoInternetException());
      } on HttpException {
        yield ValidCodeError(error: NoServiceFoundException());
      } on FormatException {
        yield ValidCodeError(error: InvalidFormatException());
      } catch (e) {
        yield ValidCodeError(error: e);
      }
    }

    if (event is ClearState) {
      yield UserInitial();
    }
  }
}
