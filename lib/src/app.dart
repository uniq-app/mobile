import 'package:flutter/material.dart';
import './shared/constants.dart';
import './router.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uniq',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Colors.teal.shade300,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: MainRouter.generateRoute,
      initialRoute: welcomeRoute,
    );
  }
}
