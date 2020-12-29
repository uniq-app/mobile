import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/picked_images/picked_images_cubit.dart';
import 'package:uniq/src/blocs/select_board_dialog/select_board_cubit.dart';
import 'package:uniq/src/services/board_api_provider.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/app_theme.dart';
import './shared/constants.dart';
import './router.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
