import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/select_board_dialog/select_board_cubit.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/services/auth_api_provider.dart';
import 'package:uniq/src/services/board_api_provider.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/services/user_api_provider.dart';
import 'package:uniq/src/shared/app_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './shared/constants.dart';
import './router.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardBloc>(
          create: (context) => BoardBloc(
              boardRepository: BoardApiProvider(),
              photoRepository: PhotoApiProvider()),
        ),
        BlocProvider<PhotoBloc>(
          create: (context) => PhotoBloc(
              boardRepository: BoardApiProvider(),
              photoRepository: PhotoApiProvider()),
        ),
        BlocProvider<SelectBoardCubit>(
          create: (context) => SelectBoardCubit(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthApiProvider(),
            fcm: FirebaseMessaging(),
          ),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            userRepository: UserApiProvider(),
          ),
        ),
      ],
      child: OKToast(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, AuthState state) {
            // State clear
            if (state is LogoutSuccess) {
              context.read<BoardBloc>().add(ClearBoardState());
              context.read<PhotoBloc>().add(ClearPhotoState());
              context.read<SelectBoardCubit>().clearState();
              context.read<UserBloc>().add(ClearState());
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Uniq',
            theme: AppTheme.mainTheme,
            onGenerateRoute: MainRouter.generateRoute,
            initialRoute: credentialsCheckRoute,
          ),
        ),
      ),
    );
  }
}
