import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/followed_boards/followed_boards_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/application_page.dart';
import 'package:uniq/src/screens/home/board_details_page.dart';
import 'package:uniq/src/screens/profile/change_email_code_page.dart';
import 'package:uniq/src/screens/profile/change_email_page.dart';
import 'package:uniq/src/screens/profile/edit_profile_page.dart';
import 'package:uniq/src/screens/profile/new_password_page.dart';
import 'package:uniq/src/screens/start/change_password_form_page.dart';
import 'package:uniq/src/screens/home/create_board_page.dart';
import 'package:uniq/src/screens/home/edit_board_page.dart';
import 'package:uniq/src/screens/credentials_check_page.dart';
import 'package:uniq/src/screens/start/forgot_password_page.dart';
import 'package:uniq/src/screens/start/change_password_code_page.dart';
import 'package:uniq/src/screens/start/register_page.dart';
import 'package:uniq/src/screens/start/login_page.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/screens/followed/search_page.dart';
import 'package:uniq/src/screens/start/welcome_page.dart';
import 'package:uniq/src/screens/start/activate_account_page.dart';
import './shared/constants.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case boardDetailsRoute:
        Board board = settings.arguments as Board;
        return MaterialPageRoute(
            builder: (_) => BoardDetailsPage(board: board));
      //Start pages routes
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case activateRoute:
        return MaterialPageRoute(
          builder: (_) => ActivateAccountPage(),
        );

      //Forgot password routes
      case forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordPage(),
        );
      case changePasswordCodeRoute:
        String email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ChangePasswordCodePage(email: email),
        );
      case changePasswordRoute:
        return MaterialPageRoute(builder: (_) => ChangePasswordPage());

      //Change email routes
      case changeEmailCodeRoute:
        return MaterialPageRoute(builder: (_) => ChangeEmailCodePage());
      case changeEmailRoute:
        return MaterialPageRoute(builder: (_) => ChangeEmailPage());
      //Change password route
      case newPasswordRoute:
        return MaterialPageRoute(builder: (_) => NewPasswordPage());
      case editProfileRoute:
        return MaterialPageRoute(builder: (_) => EditProfilePage());
      //Boards related routes
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
                  Container(
                      height: MediaQuery.of(_).size.height,
                      child: SvgPicture.asset('assets/404.svg')),
                  Text('404! ${settings.name} is leaking...'),
                ],
              ),
            ),
          ),
        );
    }
  }
}
