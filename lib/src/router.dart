import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/board_details_page.dart';
import 'package:uniq/src/screens/camera_view.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/login_page.dart';
import 'package:uniq/src/screens/photo_hero.dart';
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
        CameraDescription camera = settings.arguments as CameraDescription;
        return MaterialPageRoute(
            builder: (_) => TakePictureScreen(camera: camera));
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
