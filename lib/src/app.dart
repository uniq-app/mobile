import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/picked_images/picked_images_cubit.dart';
import 'package:uniq/src/blocs/select_board_dialog/select_board_cubit.dart';
import 'package:uniq/src/services/auth_api_provider.dart';
import 'package:uniq/src/services/board_api_provider.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/app_theme.dart';
import './shared/constants.dart';
import './router.dart';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _configureFirebase();
  }

  _configureFirebase() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardBloc>(
          create: (context) => BoardBloc(boardRepository: BoardApiProvider()),
        ),
        BlocProvider<PhotoBloc>(
          create: (context) => PhotoBloc(
              boardRepository: BoardApiProvider(),
              photoRepository: PhotoApiProvider()),
        ),
        BlocProvider<SelectBoardCubit>(
          create: (context) => SelectBoardCubit(),
        ),
        BlocProvider<PickedImagesCubit>(
          create: (context) => PickedImagesCubit(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthApiProvider()),
        ),
        BlocProvider<PageCubit>(
          create: (context) => PageCubit(),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Uniq',
          theme: AppTheme.mainTheme,
          onGenerateRoute: MainRouter.generateRoute,
          initialRoute: credentialsCheckRoute,
        ),
      ),
    );
  }
}
