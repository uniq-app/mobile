import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/board_details_page.dart';
import 'package:uniq/src/screens/create_board_page.dart';
import 'package:uniq/src/screens/edit_board_page.dart';
import 'package:uniq/src/screens/credentials_check_page.dart';
import 'package:uniq/src/screens/profile_page.dart';
import 'package:uniq/src/screens/register_page.dart';
import 'package:uniq/src/screens/take_picture_screen.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/image_library_page.dart';
import 'package:uniq/src/screens/login_page.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/screens/user_settings_page.dart';
import 'package:uniq/src/screens/welcome_page.dart';
import './shared/constants.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case boardDetailsRoute:
        Board board = settings.arguments as Board;
        return MaterialPageRoute(
            builder: (_) => BoardDetailsPage(board: board));
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case photoDetails:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (BuildContext context) => PhotoHero(
            photo: arguments['photo'],
            tag: arguments['tag'],
            onTap: () {
              Navigator.pop(context);
            },
          ),
        );
      case cameraRoute:
        return MaterialPageRoute(
          builder: (_) => TakePictureScreen(),
        );
      case imagePickerRoute:
        return MaterialPageRoute(
          builder: (_) => ImageLibraryPage(),
        );
      case createBoardRoute:
        return MaterialPageRoute(
          builder: (_) => CreateBoardPage(),
        );
      case userSettingsRoute:
        return MaterialPageRoute(
          builder: (_) => UserSettingsPage(),
        );
      case editBoardPage:
        Board board = settings.arguments as Board;
        return MaterialPageRoute(
          builder: (_) => EditBoardPage(
            board: board,
          ),
        );
      case createBoardPage:
        return MaterialPageRoute(
          builder: (_) => CreateBoardPage(),
        );
      case credentialsCheckRoute:
        return MaterialPageRoute(
          builder: (_) => CredentialsCheckPage(),
        );
      case profileRoute:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                children: [
                  Image.asset('assets/404.png'),
                  Text('404! ${settings.name} is leaking...'),
                ],
              ),
            ),
          ),
        );
    }
  }
}
