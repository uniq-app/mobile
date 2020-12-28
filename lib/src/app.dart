import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/services/board_api_provider.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/app_theme.dart';
import './shared/constants.dart';
import './router.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    Future<String> fcmToken = _fcm.getToken();
    fcmToken.then((value) => print("FCM token: $value"));
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardBloc>(
          create: (context) => BoardBloc(boardRepository: BoardApiProvider()),
        ),
        BlocProvider<PhotoBloc>(
          create: (context) => PhotoBloc(
              boardRepository: BoardApiProvider(),
              photoRepository: PhotoApiProvider()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Uniq',
        theme: AppTheme.lightTheme,
        onGenerateRoute: MainRouter.generateRoute,
        initialRoute: homeRoute,
      ),
    );
  }
}
