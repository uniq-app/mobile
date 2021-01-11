import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/utilities.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final emailController = new TextEditingController();
  final nameController = new TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  final _ForgotPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              // TODO: Zrobić działanie w oparciu o STATE
              //if (state is CodeSent) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('email with code sent!')));
              Navigator.of(context).pushNamedAndRemoveUntil(
                  changePasswordCodeRoute, (Route<dynamic> route) => false);
              //}
            },
            builder: (BuildContext context, AuthState state) {
              if (state is RegisterLoading) {
                return Loading();
              }
              return Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _ForgotPasswordKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.3,
                        child: SvgPicture.asset(
                            "assets/images/forgot_password.svg"),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "forgot password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
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
                      UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_ForgotPasswordKey.currentState.validate()) {
                            context.read<UserBloc>().add(ResetPassword(
                                email: emailController.text,
                                username: nameController.text));
//TODO : REMOVE this after functionality is finished
                            Navigator.popAndPushNamed(
                                context, changePasswordCodeRoute);
                          }
                        },
                        text: "send me code",
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("did you change your mind? -",
                              style: TextStyle(fontSize: 14)),
                          InkWell(
                            onTap: () {
                              Navigator.popAndPushNamed(context, loginRoute);
                            },
                            child: new Text(
                              " login",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
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
