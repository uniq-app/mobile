import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
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

  final _LoginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Login"),
      ),*/
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is LoginSuccess) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    applicationPage, (Route<dynamic> route) => false);
              }
            },
            builder: (BuildContext context, AuthState state) {
              if (state is LoginLoading) {
                return Loading();
              }
              return Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _LoginKey,
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
                    SizedBox(height: size.height * 0.02),
                    UniqInputField(
                      color: Theme.of(context).accentColor,
                      isObscure: true,
                      inputIcon: Icons.lock,
                      hintText: "Password",
                      controller: passwordController,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(forgotPasswordPage);
                        },
                        child: Text("Forgot password?"),
                      ),
                    ),
                    UniqButton(
                      color: Theme.of(context).buttonColor,
                      push: () {
                        context.read<AuthBloc>().add(Login(
                            username: loginController.text,
                            password: passwordController.text));
                      },
                      text: "LOGIN",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an Account?"),
                        InkWell(
                          onTap: () {
                            Navigator.popAndPushNamed(context, signupRoute);
                          },
                          child: new Text(
                            " - Sign Up",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    if (state is LoginError) Text(state.error.message),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
