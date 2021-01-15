import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class ForgotPasswordCodePage extends StatefulWidget {
  final String email;

  const ForgotPasswordCodePage({Key key, this.email}) : super(key: key);
  @override
  _ForgotPasswordCodePage createState() => _ForgotPasswordCodePage();
}

class _ForgotPasswordCodePage extends State<ForgotPasswordCodePage> {
  final codeController = new TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  _activateCode() {
    context.read<UserBloc>().add(ValidCode(code: codeController.text));
  }

  final _NewPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return BlocListener<UserBloc, UserState>(
      listener: (BuildContext context, UserState state) {
        if (state is ValidCodeSuccess) {
          Navigator.of(context)
              .pushNamed(changePasswordRoute, arguments: widget.email);
        } else if (state is ValidCodeError) {
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
              key: _NewPasswordKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: size.height * 0.3,
                      child: SvgPicture.asset("assets/images/verified.svg"),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "change your email",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(height: size.height * 0.03),
                    UniqInputIconField(
                      color: Theme.of(context).accentColor,
                      inputIcon: Icons.security,
                      isObscure: false,
                      hintText: "security code",
                      controller: codeController,
                      validator: (value) {
                        if (!value.contains(new RegExp('[0-9]{6}')))
                          return 'Invalid code';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is ValidCodeLoading) {
                          return Loading();
                        }
                        return UniqButton(
                          color: Theme.of(context).buttonColor,
                          push: () {
                            if (_NewPasswordKey.currentState.validate()) {
                              _activateCode();
                            }
                          },
                          text: "submit code",
                        );
                      },
                    ),
                    SizedBox(height: size.height * 0.01),
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
