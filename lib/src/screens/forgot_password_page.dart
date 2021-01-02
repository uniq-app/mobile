import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    SnackBar(content: Text('Resetting password successful!')));
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
                key: _ForgotPasswordKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Reset your password",
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
                      labelText: "Name",
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter the name';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    UniqInputField(
                      color: Theme.of(context).accentColor,
                      inputIcon: Icons.email,
                      isObscure: false,
                      labelText: "Email",
                      controller: emailController,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter the email';
                        if (!value.contains("@") && !value.contains("."))
                          return 'Please enter email';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    UniqButton(
                      color: Theme.of(context).buttonColor,
                      push: () {
                        if (_ForgotPasswordKey.currentState.validate()) {
                          context.read<AuthBloc>().add(ResetPassword(
                              email: emailController.text,
                              username: nameController.text));
                        }
                      },
                      text: "RESET MY PASSWORD",
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
