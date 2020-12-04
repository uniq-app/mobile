import 'package:flutter/material.dart';
import 'package:uniq/src/screens/board_details_page.dart';
import 'package:uniq/src/screens/home_page.dart';
import './shared/constants.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Router: $settings');
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage(title: 'uniq'));
      case boardDetailsRoute:
        return MaterialPageRoute(builder: (_) => BoardDetailsPage());
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
