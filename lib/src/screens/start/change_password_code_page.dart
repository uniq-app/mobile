import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class ChangePasswordCodePage extends StatefulWidget {
  final String email;

  const ChangePasswordCodePage({Key key, this.email}) : super(key: key);
  @override
  _ChangePasswordCodePage createState() => _ChangePasswordCodePage();
}

class _ChangePasswordCodePage extends State<ChangePasswordCodePage> {
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
          child: BlocConsumer<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {
              if (state is ValidCodeSuccess) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Code is correct!')));
                Navigator.of(context).pushNamed(changePasswordRoute);
              }
              if (state is ValidCodeError) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Code is wrong!')));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    changePasswordRoute, (Route<dynamic> route) => false);
              }
            },
            builder: (BuildContext context, UserState state) {
              if (state is ResetPasswordLoading) {
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
                        child: SvgPicture.asset("assets/images/form.svg"),
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
                        inputIcon: Icons.security,
                        isObscure: false,
                        labelText: "security code",
                        controller: codeController,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter the name';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_NewPasswordKey.currentState.validate()) {
                            context
                                .read<UserBloc>()
                                .add(ValidCode(code: codeController.text));
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
