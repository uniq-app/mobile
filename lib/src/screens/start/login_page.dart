import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

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
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            if (state is LoginSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  applicationPage, (Route<dynamic> route) => false);
            }
            if (state is LoginError) {
              showToast(
                "${state.error.message}",
                position: ToastPosition.bottom,
                backgroundColor: Colors.redAccent,
              );
            }
          },
          builder: (BuildContext context, AuthState state) {
            if (state is LoginLoading) {
              return Loading();
            }
            return Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _LoginKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.3,
                        child: SvgPicture.asset("assets/images/create.svg"),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "login to UNIQ",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: size.height * 0.02),
                      UniqInputIconField(
                        color: Theme.of(context).accentColor,
                        inputIcon: Icons.email,
                        isObscure: false,
                        hintText: "email",
                        controller: loginController,
                        validator: (value) {
                          if (value.isEmpty) return "Name cannot be empty";
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      UniqInputIconField(
                        color: Theme.of(context).accentColor,
                        isObscure: true,
                        inputIcon: Icons.lock,
                        hintText: "password",
                        controller: passwordController,
                        validator: (value) {
                          if (value.isEmpty) return "Password cannot be empty";
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(activateRoute);
                            },
                            child: Text(
                              "activate account",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(forgotPasswordRoute);
                            },
                            child: Text(
                              "forgot password",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_LoginKey.currentState.validate()) {
                            context.read<AuthBloc>().add(
                                  Login(
                                    username: loginController.text,
                                    password: passwordController.text,
                                  ),
                                );
                          }
                        },
                        text: "login",
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "don't have an account?",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.popAndPushNamed(context, signupRoute);
                            },
                            child: new Text(
                              " - register",
                              style: Theme.of(context).textTheme.button,
                            ),
                          )
                        ],
                      ),
                      if (state is LoginError) Text(state.error.message),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
