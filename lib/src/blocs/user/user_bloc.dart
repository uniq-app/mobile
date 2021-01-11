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
    if (event is ClearState) {
      yield UserInitial();
    }
  }
}
