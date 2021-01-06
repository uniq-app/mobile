import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/application_page.dart';
import 'package:uniq/src/screens/board_details_page.dart';
import 'package:uniq/src/screens/create_board_page.dart';
import 'package:uniq/src/screens/edit_board_page.dart';
import 'package:uniq/src/screens/credentials_check_page.dart';
import 'package:uniq/src/screens/forgot_password_page.dart';
import 'package:uniq/src/screens/new_password_page.dart';
import 'package:uniq/src/screens/register_page.dart';
import 'package:uniq/src/screens/login_page.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/screens/welcome_page.dart';
import './shared/constants.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
            url: arguments['url'],
            tag: arguments['tag'],
            image: arguments['image'],
            onTap: () {
              Navigator.pop(context);
            },
          ),
        );
      case createBoardRoute:
        return MaterialPageRoute(
          builder: (_) => CreateBoardPage(),
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
      case forgotPasswordPage:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordPage(),
        );
      case newPasswordPage:
        return MaterialPageRoute(
          builder: (_) => NewPasswordPage(),
        );
      case applicationPage:
        return MaterialPageRoute(
          builder: (_) => ApplicationPage(),
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
