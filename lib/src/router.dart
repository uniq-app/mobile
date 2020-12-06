import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/screens/board_details_page.dart';
import 'package:uniq/src/screens/camera_view.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import './shared/constants.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Router: $settings');
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage(title: 'uniq'));
      case boardDetailsRoute:
        return MaterialPageRoute(builder: (_) => BoardDetailsPage());
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