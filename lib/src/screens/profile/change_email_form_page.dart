import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/utilities.dart';

class ChangeEmailPage extends StatefulWidget {
  final String email;

  const ChangeEmailPage({Key key, this.email}) : super(key: key);
  @override
  _ChangeEmailPage createState() => _ChangeEmailPage();
}

class _ChangeEmailPage extends State<ChangeEmailPage> {
  final codeController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  final _NewEmailKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              //if (state is EmailChangeSuccess) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Changing email successful!')));
              Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute, (Route<dynamic> route) => false);
              //}
            },
            builder: (BuildContext context, AuthState state) {
              if (state is RegisterLoading) {
                return Loading();
              }
              return Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _NewEmailKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.3,
                        child: SvgPicture.asset("assets/images/form.svg"),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "change your email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      UniqInputIconField(
                        color: Theme.of(context).accentColor,
                        inputIcon: Icons.security,
                        isObscure: false,
                        labelText: "security code",
                        controller: codeController,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter the name';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      UniqInputIconField(
                        color: Theme.of(context).accentColor,
                        isObscure: true,
                        inputIcon: Icons.lock,
                        labelText: "new email",
                        controller: passwordController,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter the email';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      UniqInputIconField(
                        color: Theme.of(context).accentColor,
                        isObscure: true,
                        inputIcon: Icons.lock,
                        labelText: "password",
                        controller: passwordController,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter the password';

                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_NewEmailKey.currentState.validate()) {
                            context.read<UserBloc>().add(NewPassword(
                                safetyCode: codeController.text,
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
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
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
