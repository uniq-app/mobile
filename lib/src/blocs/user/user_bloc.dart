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
        print("ActivateLoading");
        yield ActivateSuccess();
      } on SocketException {
        yield ActivateError(error: NoInternetException('No internet'));
      } on HttpException {
        yield ActivateError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield ActivateError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield ActivateError(error: NoInternetException('Unknown error: $e'));
      }
    }
  }
}
