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
        await authRepository.login(event.username, event.password);
        yield LoginSuccess();
      } on SocketException {
        yield LoginError(error: NoInternetException());
      } on HttpException {
        yield LoginError(error: NoServiceFoundException());
      } on FormatException {
        yield LoginError(error: InvalidFormatException());
      } catch (e) {
        yield LoginError(error: e);
      }
    }
    if (event is Logout) {
      yield LogoutLoading();
      await authRepository.logout();
      token = "";
      yield LogoutSuccess();
    }
    if (event is Register) {
      yield RegisterLoading();
      try {
        token = await authRepository.register(
            event.username, event.email, event.password);
        yield RegisterSuccess();
      } on SocketException {
        yield RegisterError(error: NoInternetException());
      } on HttpException {
        yield RegisterError(error: NoServiceFoundException());
      } on FormatException {
        yield RegisterError(error: InvalidFormatException());
      } catch (e) {
        yield RegisterError(error: e);
      }
    }
  }
}
