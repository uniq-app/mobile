import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPage createState() => _ChangePasswordPage();
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _NewPasswordKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.3,
                        child: SvgPicture.asset("assets/images/password.svg"),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "change your password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      UniqInputIconField(
                        color: Theme.of(context).accentColor,
                        isObscure: true,
                        inputIcon: Icons.lock,
                        labelText: "new password",
                        controller: passwordController,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter the password';
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
                          if (value.isEmpty) return 'Please enter the password';
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
                            context.read<UserBloc>().add(ResetPassword(
                                email: codeController.text,
                                password: passwordController.text));
                          }
                        },
                        text: "change my password",
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("did not receive code? -",
                              style: TextStyle(fontSize: 14)),
                          InkWell(
                            onTap: () {
                              showToast(
                                "Not implemented yet",
                                position: ToastPosition.bottom,
                                backgroundColor: Colors.redAccent,
                              );
                            },
                            child: new Text(
                              " resend email",
                              style: Theme.of(context).textTheme.button,
                            ),
                          )
                        ],
                      ),
                    ],
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
