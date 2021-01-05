import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/utilities.dart';

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
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is RegisterSuccess) {
                showToast(
                  "Account successfuly created!",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.green[400],
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, (Route<dynamic> route) => false);
              } else if (state is RegisterError) {
                showToast(
                  "Failed to create account - ${state.error.message}",
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
                        if (!value.contains("@") || !value.contains("."))
                          return 'Please enter correct email';
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
                      text: "REGISTER",
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an Account? -"),
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
