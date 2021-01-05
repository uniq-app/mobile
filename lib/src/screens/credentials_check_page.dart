import 'package:flutter/material.dart';
import 'package:uniq/src/screens/application_page.dart';
import 'package:uniq/src/screens/welcome_page.dart';
import 'package:uniq/src/services/auth_api_provider.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:move_to_background/move_to_background.dart';
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
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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
          return WillPopScope(
            onWillPop: () async {
              MoveToBackground.moveTaskToBack();
              return false;
            },
            child: ApplicationPage(),
            //child: loadSplashScreen(context),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //TODO: Splash screen here?
          print("Snapshot waiting");
          return Center(
            child: Text('Loading..'),
          );
        }
        return WelcomePage();
      },
    );
  }
}
