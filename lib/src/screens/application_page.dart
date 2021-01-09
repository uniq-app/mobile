import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/followed_boards/followed_boards_bloc.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:uniq/src/screens/followed_boards.dart';

import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/image_library_page.dart';
import 'package:uniq/src/screens/take_photo_screen.dart';
import 'package:uniq/src/screens/user_settings_page.dart';
import 'package:uniq/src/services/board_api_provider.dart';
import 'package:uniq/src/services/profile_api_provider.dart';
import 'package:uniq/src/shared/components/bottom_navbar.dart';
import 'package:move_to_background/move_to_background.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext _) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageCubit>(
          create: (context) => PageCubit(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(profileRepository: ProfileApiProvider()),
        ),
        BlocProvider<FollowedBoardsBloc>(
          create: (context) =>
              FollowedBoardsBloc(boardRepository: BoardApiProvider()),
        ),
      ],
      child: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async {
            List<PageState> currentStack = context.read<PageCubit>().pageStack;
            if (currentStack.last == PageState.homePage)
              MoveToBackground.moveTaskToBack();
            else
              context.read<PageCubit>().popOne();

            return false;
          },
          child: Scaffold(
            body: BlocBuilder<PageCubit, PageState>(
              builder: (BuildContext context, PageState state) {
                if (state == PageState.homePage) {
                  return HomePage();
                } else if (state == PageState.followedBoardsPage) {
                  return FollowedBoards();
                } else if (state == PageState.cameraPage) {
                  return TakePhotoScreen();
                } else if (state == PageState.libraryPage) {
                  return ImageLibraryPage();
                } else if (state == PageState.profilePage) {
                  return UserSettingsPage();
                }
                return HomePage();
              },
            ),
            bottomNavigationBar: BottomNavbar(),
          ),
        ),
      ),
    );
  }
}
