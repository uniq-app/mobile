import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class SendNewTokenPage extends StatefulWidget {
  @override
  _SendNewTokenPageState createState() => _SendNewTokenPageState();
}

class _SendNewTokenPageState extends State<SendNewTokenPage> {
  final emailController = new TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  _sendNewCode() {
    context.read<UserBloc>().add(ResendCode(email: emailController.text));
  }

  final _emailKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        if (state is ResendCodeSuccess) {
          showToast(
            "security code sent",
            position: ToastPosition.bottom,
            backgroundColor: Colors.green,
          );
          Navigator.of(context).pop();
        } else if (state is ResendCodeError) {
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
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _emailKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: size.height * 0.35,
                      child: SvgPicture.asset("assets/images/completed.svg"),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "resend security code",
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
                          return 'Please enter correct email';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "we will send you security code for authorization",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: size.height * 0.03),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, UserState state) {
                        if (state is ResendCodeLoading) {
                          return Loading();
                        }
                        return UniqButton(
                          color: Theme.of(context).buttonColor,
                          push: () {
                            if (_emailKey.currentState.validate()) {
                              _sendNewCode;
                            }
                          },
                          text: "send security code",
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
