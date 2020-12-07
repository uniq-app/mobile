import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class WelcomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome to UNIQ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        SizedBox(height: size.height * 0.05),
        SizedBox(height: size.height * 0.05),
        UniqButton(
          text: "LOGIN",
          push: () {
            Navigator.pushReplacementNamed(context, loginRoute);
          },
        ),
        UniqButton(
          text: "SIGN UP",
          color: lightColor,
          textColor: Colors.black,
          push: () {
            Navigator.pushReplacementNamed(context, signupRoute);
          },
        ),
      ],
    )));
  }
}
