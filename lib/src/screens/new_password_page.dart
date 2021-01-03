import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/utilities.dart';

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPage createState() => _NewPasswordPage();
}

class _NewPasswordPage extends State<NewPasswordPage> {
  final codeController = new TextEditingController();
  final passwordController = new TextEditingController();
  final passwordController2 = new TextEditingController();
  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  final _NewPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Reset password"),
      ),*/
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is RegisterSuccess) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Changing password successful!')));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, (Route<dynamic> route) => false);
              }
            },
            builder: (BuildContext context, AuthState state) {
              if (state is RegisterLoading) {
                return Loading();
              }
              return Form(
                autovalidate: true,
                key: _NewPasswordKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Change your password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    UniqInputField(
                      color: Theme.of(context).accentColor,
                      inputIcon: Icons.face,
                      isObscure: false,
                      labelText: "CODE",
                      controller: codeController,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter the name';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    UniqInputField(
                      color: Theme.of(context).accentColor,
                      isObscure: true,
                      inputIcon: Icons.lock,
                      labelText: "Password",
                      controller: passwordController,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter the password';
                        if (passwordController.text != passwordController2.text)
                          return 'Passwords are not equal';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    UniqInputField(
                      color: Theme.of(context).accentColor,
                      isObscure: true,
                      inputIcon: Icons.lock,
                      labelText: "Repeat password",
                      controller: passwordController2,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter the password';
                        if (passwordController.text != passwordController2.text)
                          return 'Passwords are not equal';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    UniqButton(
                      color: Theme.of(context).buttonColor,
                      push: () {
                        if (_NewPasswordKey.currentState.validate()) {
                          context.read<AuthBloc>().add(NewPassword(
                              safetyCode: codeController.text,
                              password: passwordController.text));
                        }
                      },
                      text: "CHANGE PASSWORD",
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Did you change your mind? -"),
                        InkWell(
                          onTap: () {
                            Navigator.popAndPushNamed(context, loginRoute);
                          },
                          child: new Text(
                            " Login",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
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
