import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class NewPasswordPage extends StatefulWidget {
  NewPasswordPage({Key key}) : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final oldPasswordController = new TextEditingController();
  final passwordController = new TextEditingController();
  final passwordController2 = new TextEditingController();
  @override
  void dispose() {
    oldPasswordController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  final _NewPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        // TODO: implement listener
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Center(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (BuildContext context, AuthState state) {
                if (state is RegisterSuccess) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Changing password successful!')));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      editProfileRoute, (Route<dynamic> route) => false);
                }
              },
              builder: (BuildContext context, AuthState state) {
                if (state is RegisterLoading) {
                  return Loading();
                }
                return Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _NewPasswordKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: size.height * 0.3,
                          child: SvgPicture.asset(
                              "assets/images/authentication.svg"),
                        ),
                        SizedBox(height: size.height * 0.03),
                        UniqInputIconField(
                          color: Theme.of(context).accentColor,
                          inputIcon: Icons.lock_outline,
                          isObscure: true,
                          labelText: "old password",
                          controller: oldPasswordController,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter the password';
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        UniqInputIconField(
                          color: Theme.of(context).accentColor,
                          isObscure: true,
                          inputIcon: Icons.lock,
                          labelText: "new password",
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter the password';
                            if (passwordController.text !=
                                passwordController2.text)
                              return 'Passwords are not equal';
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        UniqInputIconField(
                          color: Theme.of(context).accentColor,
                          isObscure: true,
                          inputIcon: Icons.lock,
                          labelText: "repeat password",
                          controller: passwordController2,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter the password';
                            if (passwordController.text !=
                                passwordController2.text)
                              return 'Passwords are not equal';
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.03),
                        UniqButton(
                          color: Theme.of(context).buttonColor,
                          push: () {
                            if (_NewPasswordKey.currentState.validate()) {
                              // TODO: BLOC implementation
                              /*context.read<UserBloc>().add(ChangePassword(
                                oldPassword: oldPasswordController.text,
                                password: passwordController.text));*/
                            }
                          },
                          text: "change my password",
                        ),
                        SizedBox(height: size.height * 0.01),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}