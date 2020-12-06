import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginController = new TextEditingController();
    final passwdController = new TextEditingController();
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login to UNIQ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            UniqInputField(
              isObscure: false,
              hintText: "Email",
            ),
            UniqInputField(
              isObscure: true,
              hintText: "Password",
            ),
            SizedBox(height: size.height * 0.05),
            UniqButton(
              push: () {
                Navigator.pushNamed(context, homeRoute);
              },
              text: "LOGIN",
            ),
          ],
        )));
  }
}
