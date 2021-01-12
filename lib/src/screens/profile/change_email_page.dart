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
  final emailController = new TextEditingController();
  final emailController2 = new TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    emailController2.dispose();
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
          //                  <UserBloc, UserState>
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              // if (state is UpdateEmailSuccess)
              // if (state is UpdateEmailError)
              //if (state is EmailChangeSuccess) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('email with code sent')));
              Navigator.of(context).pushNamedAndRemoveUntil(
                  changeEmailRoute, (Route<dynamic> route) => false);
              //}
            },
            //                              UserState
            builder: (BuildContext context, AuthState state) {
              // if (state is UpdateEmailLoading)
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
                        child: SvgPicture.asset("assets/images/chill.svg"),
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
                        inputIcon: Icons.email,
                        isObscure: false,
                        hintText: "new email",
                        controller: emailController,
                        validator: (value) {
                          if (!value.contains(new RegExp('\@*\.')))
                            return 'Invalid code';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      UniqInputIconField(
                        color: Theme.of(context).accentColor,
                        inputIcon: Icons.email,
                        isObscure: false,
                        hintText: "repeat email",
                        controller: emailController2,
                        validator: (value) {
                          if (!value.contains(new RegExp('\@*\.')))
                            return 'Invalid code';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_NewPasswordKey.currentState.validate()) {
                            //Navigator.of(context).pushNamed(changeEmailRoute);
                          }
                        },
                        text: "change email",
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
    );
  }
}
