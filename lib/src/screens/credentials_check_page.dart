import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/screens/application_page.dart';
import 'package:uniq/src/screens/welcome_page.dart';
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
          return ApplicationPage();
          //child: loadSplashScreen(context),
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //TODO: Splash screen here?
          precachePicture(
            ExactAssetPicture(
                SvgPicture.svgStringDecoder, 'assets/images/imagination.svg'),
            context,
          );
          precachePicture(
            ExactAssetPicture(
                SvgPicture.svgStringDecoder, "assets/images/create.svg"),
            context,
          );
          print("Snapshot waiting");
          return Scaffold(
            body: Loading(),
          );
        }
        return WelcomePage();
      },
    );
  }
}
