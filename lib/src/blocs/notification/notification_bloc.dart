import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/repositories/notification_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;
  final FirebaseMessaging fcm;
  String token;

  NotificationBloc({@required this.notificationRepository, this.fcm})
      : super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is UpdateFcm) {
      yield UpdateFcmLoading();
      try {
        if (event.isEnabled) {
          token = await fcm.getToken();
        } else
          token = null;
        await notificationRepository.updateFCM(token);
        yield UpdateFcmSuccess();
      } on SocketException {
        yield UpdateFcmError(error: NoInternetException());
      } on HttpException {
        yield UpdateFcmError(error: NoServiceFoundException());
      } on FormatException {
        yield UpdateFcmError(error: InvalidFormatException());
      } catch (e) {
        yield UpdateFcmError(error: e);
      }
    }
  }
}
