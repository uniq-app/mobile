import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

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

  _updatePassword() {
    context.read<UserBloc>().add(UpdatePassword(
        oldPassword: oldPasswordController.text,
        newPassword: passwordController.text));
  }

  final _newPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        if (state is UpdatePasswordSuccess) {
          Navigator.pop(context);
          showToast(
            "Successfuly updated password!",
            position: ToastPosition.bottom,
            backgroundColor: Colors.green,
          );
        } else if (state is UpdatePasswordError) {
          showToast(
            "${state.error.message}",
            position: ToastPosition.bottom,
            backgroundColor: Colors.redAccent,
          );
        }
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
                  key: _newPasswordKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: size.height * 0.3,
                          child: SvgPicture.asset(
                              "assets/images/authentication.svg"),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          "change password",
                          style: Theme.of(context).textTheme.headline3,
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
                        SizedBox(height: size.height * 0.03),
                        UniqButton(
                          color: Theme.of(context).buttonColor,
                          push: () {
                            if (_newPasswordKey.currentState.validate()) {
                              _updatePassword();
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
