import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:uniq/src/repositories/auth_repository.dart';
import 'package:uniq/src/services/exceptions.dart';

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
    if (event is Signup) {
      yield SignupLoading();
      try {
        token = await authRepository.register(
            event.username, event.email, event.password);
        yield SignupSuccess(token: token);
      } on SocketException {
        yield SignupError(error: NoInternetException('No internet'));
      } on HttpException {
        yield SignupError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield SignupError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield SignupError(error: NoInternetException('Unknown error: $e'));
      }
    }
  }
}
