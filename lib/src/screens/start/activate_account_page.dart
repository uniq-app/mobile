import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';
import 'package:oktoast/oktoast.dart';

class ActivateAccountPage extends StatefulWidget {
  @override
  _ActivateAccountPageState createState() => _ActivateAccountPageState();
}

class _ActivateAccountPageState extends State<ActivateAccountPage> {
  final codeController = new TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  _resendEmail() {
    Navigator.of(context).pushNamed(sendNewTokenPage);
  }

  final _ActivateKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Width and length of the screen
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Login"),
      ),*/
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocConsumer<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {
              if (state is ActivateSuccess) {
                showToast(
                  "Account successfuly activated!",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.green[400],
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, (Route<dynamic> route) => false);
              } else if (state is ActivateError) {
                showToast(
                  "Error during activation process",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.red[400],
                );
              }
            },
            builder: (BuildContext context, UserState state) {
              if (state is ActivateLoading) {
                return Loading();
              }
              return Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _ActivateKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: size.height * 0.3,
                      child: SvgPicture.asset("assets/images/verified.svg"),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "activate UNIQ account",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(height: size.height * 0.03),
                    UniqInputIconField(
                      color: Theme.of(context).accentColor,
                      inputIcon: Icons.security,
                      isObscure: false,
                      hintText: "Security code",
                      controller: codeController,
                      validator: (value) {
                        if (!value.contains(new RegExp('[0-9]{6}')))
                          return 'Invalid code';

                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "enter the security code that we sent you to your e-mail",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: size.height * 0.02),
                    UniqButton(
                      color: Theme.of(context).buttonColor,
                      push: () {
                        if (_ActivateKey.currentState.validate()) {
                          context
                              .read<UserBloc>()
                              .add(Activate(code: codeController.text));
                        }
                      },
                      text: "activate",
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("did not receive code? -",
                            style: TextStyle(fontSize: 14)),
                        InkWell(
                          onTap: () {
                            _resendEmail();
                          },
                          child: new Text(
                            " resend email",
                            style: Theme.of(context).textTheme.button,
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: size.height * 0.03,
                    // ),
                    // if (state is ActivateError) Text(state.error.message),
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
