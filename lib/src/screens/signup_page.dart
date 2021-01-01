import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/utilities.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  final emailController = new TextEditingController();
  final nameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final passwordController2 = new TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  final _signupKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Signup"),
      ),*/
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            if (state is LoginSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  homeRoute, (Route<dynamic> route) => false);
            }
          },
          builder: (BuildContext context, AuthState state) {
            if (state is LoginLoading) {
              return Loading();
            }
            return Form(
              key: _signupKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Create UNIQ account",
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
                    hintText: "Name",
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter the name';
                      return null;
                    },
                  ),
                  UniqInputField(
                    color: Theme.of(context).accentColor,
                    inputIcon: Icons.email,
                    isObscure: false,
                    hintText: "Email",
                    controller: emailController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter the email';
                      if (!value.contains("@") && !value.contains("."))
                        return 'Please enter email';
                      return null;
                    },
                  ),
                  UniqInputField(
                    color: Theme.of(context).accentColor,
                    isObscure: true,
                    inputIcon: Icons.lock,
                    hintText: "Password",
                    controller: passwordController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter the password';
                      if (passwordController.text != passwordController2.text)
                        return 'Passwords are not equal';
                      return null;
                    },
                  ),
                  UniqInputField(
                    color: Theme.of(context).accentColor,
                    isObscure: true,
                    inputIcon: Icons.lock,
                    hintText: "Repeat password",
                    controller: passwordController2,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter the password';
                      if (passwordController.text != passwordController2.text)
                        return 'Passwords are not equal';
                      return null;
                    },
                  ),
                  if (state is LoginError) Text(state.error.message),
                  SizedBox(height: size.height * 0.03),
                  UniqButton(
                    color: Theme.of(context).buttonColor,
                    push: () {
                      if (_signupKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                        context.read<AuthBloc>().add(Signup(
                            email: emailController.text,
                            username: nameController.text,
                            password: passwordController.text));
                      }
                    },
                    text: "SIGN UP",
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an Account?"),
                      InkWell(
                        onTap: () {
                          Navigator.popAndPushNamed(context, loginRoute);
                        },
                        child: new Text(
                          " - Login",
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
    );
  }
}
