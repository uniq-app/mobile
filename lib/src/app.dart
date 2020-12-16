import 'package:flutter/material.dart';
import 'package:uniq/src/shared/app_theme.dart';
import './shared/constants.dart';
import './router.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uniq',
      theme: AppTheme.lightTheme,
      onGenerateRoute: MainRouter.generateRoute,
      initialRoute: welcomeRoute,
    );
  }
}
