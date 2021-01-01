import 'package:flutter/material.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/welcome_page.dart';
import 'package:uniq/src/services/auth_api_provider.dart';
import 'package:uniq/src/shared/components/loading.dart';

class CredentialsCheckPage extends StatelessWidget {
  final authApiProvider = AuthApiProvider();

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authApiProvider.getToken(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //TODO: Splash screen here?
          return Loading();
        }
        return WelcomePage();
      },
    );
  }
}
