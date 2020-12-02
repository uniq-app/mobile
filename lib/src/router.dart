import 'package:flutter/material.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/test_route.dart';
import './shared/constants.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Router: $settings');
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage(title: 'uniq'));
      case testRoute:
        return MaterialPageRoute(builder: (_) => TestRoute());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                children: [
                  Image.asset('assets/404.png'),
                  Text('${settings.name} is leaking...'),
                ],
              ),
            ),
          ),
        );
    }
  }
}
