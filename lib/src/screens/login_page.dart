import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).accentColor,
              inputIcon: Icons.email,
              isObscure: false,
              hintText: "Email",
              controller: loginController,
            ),
            UniqInputField(
              color: Theme.of(context).accentColor,
              isObscure: true,
              inputIcon: Icons.lock,
              hintText: "Password",
              controller: passwordController,
            ),
            SizedBox(height: size.height * 0.05),
            UniqButton(
              color: Theme.of(context).buttonColor,
              push: () {
                context.read<AuthBloc>().add(Login(
                    username: loginController.text,
                    password: passwordController.text));

                //Navigator.of(context).pushNamedAndRemoveUntil(
                //    homeRoute, (Route<dynamic> route) => false);
                Navigator.of(context).pushNamed(homeRoute);
              },
              text: "LOGIN",
            ),
          ],
        ),
      ),
    );
  }
}
