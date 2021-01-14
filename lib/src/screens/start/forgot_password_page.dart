import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final emailController = new TextEditingController();
  final nameController = new TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  _forgotPassword() {
    context.read<UserBloc>().add(ForgotPassword(email: emailController.text));
  }

  final _ForgotPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        if (state is ForgotPasswordSuccess) {
          Navigator.pushNamed(context, forgotPasswordCodePage,
              arguments: emailController.text);
        }
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Center(
              child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _ForgotPasswordKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: size.height * 0.3,
                    child:
                        SvgPicture.asset("assets/images/forgot_password.svg"),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "forgot password",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(height: size.height * 0.03),
                  UniqInputIconField(
                    color: Theme.of(context).accentColor,
                    inputIcon: Icons.email,
                    isObscure: false,
                    labelText: "email",
                    controller: emailController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter the email';
                      if (!value.contains("@") || !value.contains("."))
                        return 'Please enter email';
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "we will send you security code for authorization",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: size.height * 0.03),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, UserState state) {
                      if (state is ForgotPasswordLoading) {
                        return Loading();
                      }
                      return UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_ForgotPasswordKey.currentState.validate()) {
                            _forgotPassword();
                          }
                        },
                        text: "send security code",
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("did you change your mind? -",
                          style: TextStyle(fontSize: 14)),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
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
          )),
        ),
      ),
    );
  }
}
