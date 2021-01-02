import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/welcome_page.dart';
import 'package:uniq/src/services/auth_api_provider.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:move_to_background/move_to_background.dart';

class CredentialsCheckPage extends StatelessWidget {
  final authApiProvider = AuthApiProvider();
  var _androidAppRetain = MethodChannel("android_app_retain");

  _willPop(context) {
    if (Platform.isAndroid) {
      if (Navigator.of(context).canPop()) {
        return Future.value(true);
      } else {
        _androidAppRetain.invokeMethod("sendToBackground");
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authApiProvider.getToken(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          //TODO: Średnie rozwiazanie
          return WillPopScope(
            onWillPop: () async {
              MoveToBackground.moveTaskToBack();
              return false;
            },
            child: HomePage(),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //TODO: Splash screen here?
          return Loading();
        }
        return WelcomePage();
      },
    );
  }
}
