import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
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

  final _RegisterKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Register"),
      ),*/
      body: Container(
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is RegisterSuccess) {
                showToast(
                  "Account successfuly created!",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.green[400],
                );
                Navigator.of(context).pushNamed(activateRoute);
              } else if (state is RegisterError) {
                showToast(
                  "${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            builder: (BuildContext context, AuthState state) {
              if (state is RegisterLoading) {
                return Loading();
              }
              return Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _RegisterKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "create UNIQ account",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SizedBox(height: size.height * 0.05),
                        UniqInputIconField(
                          color: Theme.of(context).accentColor,
                          inputIcon: Icons.face,
                          isObscure: false,
                          labelText: "name",
                          controller: nameController,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter the name';
                            else if (value.length < 5)
                              return 'Name is too short';
                            else if (value.length > 15)
                              return 'Name is too long';
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.015),
                        UniqInputIconField(
                          color: Theme.of(context).accentColor,
                          inputIcon: Icons.email,
                          isObscure: false,
                          labelText: "email",
                          controller: emailController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email cannot be empty";
                            } else if (!value.contains(new RegExp(
                                r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")))
                              return 'Invalid email';
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.015),
                        UniqInputIconField(
                          color: Theme.of(context).accentColor,
                          isObscure: true,
                          inputIcon: Icons.lock,
                          labelText: "password",
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter the password';
                            else if (value.length < 8) {
                              return "Password is too short";
                            }
                            if (!value.contains(new RegExp('[A-Z]+')))
                              return 'Password must contain at least 1 capital letter';
                            else if (!value.contains(new RegExp('[a-z]+')))
                              return 'Password must contain at least lowercase 1 letter';
                            else if (!value.contains(new RegExp('[0-9]+')))
                              return 'Password must contain at least 1 number';
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.015),
                        UniqInputIconField(
                          color: Theme.of(context).accentColor,
                          isObscure: true,
                          inputIcon: Icons.lock,
                          labelText: "repeat password",
                          controller: passwordController2,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter the password';
                            else if (value.length < 8) {
                              return "Password is too short";
                            }
                            if (!value.contains(new RegExp('[A-Z]+')))
                              return 'Password must contain at least 1 capital letter';
                            else if (!value.contains(new RegExp('[a-z]+')))
                              return 'Password must contain at least lowercase 1 letter';
                            else if (!value.contains(new RegExp('[0-9]+')))
                              return 'Password must contain at least 1 number';
                            else if (passwordController.text !=
                                passwordController2.text)
                              return 'Passwords are not equal';
                            return null;
                          },
                        ),
                        if (state is RegisterError) Text(state.error.message),
                        SizedBox(height: size.height * 0.03),
                        UniqButton(
                          color: Theme.of(context).buttonColor,
                          push: () {
                            if (_RegisterKey.currentState.validate()) {
                              context.read<AuthBloc>().add(Register(
                                  email: emailController.text,
                                  username: nameController.text,
                                  password: passwordController.text));
                            }
                          },
                          text: "register",
                          fontSize: 16,
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "already have an account? -",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.popAndPushNamed(context, loginRoute);
                              },
                              child: new Text(
                                " login",
                                style: Theme.of(context).textTheme.button,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
