import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/screens/application_page.dart';
import 'package:uniq/src/screens/start/welcome_page.dart';
import 'package:uniq/src/services/auth_api_provider.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:splashscreen/splashscreen.dart';

class CredentialsCheckPage extends StatelessWidget {
  final authApiProvider = AuthApiProvider();

/* 
  Future<Widget> loadFromFuture() async {
    // <fetch data from server. ex. login>
    await Future.delayed(Duration(seconds: 2));
    return Future.value(new ApplicationPage());
  }

  loadSplashScreen(context) {
    return new SplashScreen(
        navigateAfterFuture: loadFromFuture(),
        title: new Text(
          'Welcome In SplashScreen',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.grey);
  }
*/

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authApiProvider.getToken(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ApplicationPage();
          //child: loadSplashScreen(context),
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //TODO: Splash screen here?

          print("Snapshot waiting");
          return Scaffold();
        }
        return WelcomePage();
      },
    );
  }
}
