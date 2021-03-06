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

class ChangeEmailCodePage extends StatefulWidget {
  final String email;

  const ChangeEmailCodePage({Key key, this.email}) : super(key: key);
  @override
  _ChangeEmailCodePage createState() => _ChangeEmailCodePage();
}

class _ChangeEmailCodePage extends State<ChangeEmailCodePage> {
  final codeController = new TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  _activateCode() {
    context.read<UserBloc>().add(ValidCode(code: codeController.text));
  }

  _resendEmail() {
    Navigator.of(context).pushNamed(sendNewTokenPage);
  }

  final _NewPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocConsumer<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {
              if (state is ValidCodeSuccess) {
                Navigator.of(context).pushNamed(changeEmailRoute,
                    arguments: codeController.text);
              } else if (state is ValidCodeError) {
                showToast(
                  "${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            builder: (BuildContext context, UserState state) {
              if (state is ValidCodeLoading) {
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
                      UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_NewPasswordKey.currentState.validate()) {
                            _activateCode();
                          }
                        },
                        text: "submit code",
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("did not receive code? -",
                              style: Theme.of(context).textTheme.caption),
                          InkWell(
                            onTap: () {
                              _resendEmail();
                            },
                            child: Text(
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
