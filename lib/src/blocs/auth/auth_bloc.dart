import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/repositories/auth_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  String token;

  AuthBloc({this.authRepository}) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is Login) {
      yield LoginLoading();
      try {
        token = await authRepository.login(event.username, event.password);
        yield LoginSuccess(token: token);
      } on SocketException {
        yield LoginError(error: NoInternetException('No internet'));
      } on HttpException {
        yield LoginError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield LoginError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield LoginError(error: NoInternetException('Unknown error: $e'));
      }
    }
    if (event is Logout) {
      yield LogoutLoading();
      await authRepository.logout();
      yield LogoutSuccess();
    }
    if (event is Register) {
      yield RegisterLoading();
      try {
        token = await authRepository.register(
            event.username, event.email, event.password);
        print("SignupLoading");
        yield RegisterSuccess();
      } on SocketException {
        yield RegisterError(error: NoInternetException('No internet'));
      } on HttpException {
        yield RegisterError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield RegisterError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield RegisterError(error: NoInternetException('Unknown error: $e'));
      }
    }
  }
}
