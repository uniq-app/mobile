import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/utilities.dart';
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
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
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
                  "Error during activation process :(",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.red[400],
                );
              }
            },
            builder: (BuildContext context, AuthState state) {
              if (state is ActivateLoading) {
                return Loading();
              }
              return Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _ActivateKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Activate UNIQ account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
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
                    SizedBox(height: size.height * 0.03),
                    UniqButton(
                      color: Theme.of(context).buttonColor,
                      push: () {
                        if (_ActivateKey.currentState.validate()) {
                          context
                              .read<AuthBloc>()
                              .add(Activate(code: codeController.text));
                        }
                      },
                      text: "ACTIVATE",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Did not received code?"),
                        InkWell(
                          onTap: () {
                            showToast(
                              "Not implemented yet",
                              position: ToastPosition.bottom,
                              backgroundColor: Colors.redAccent,
                            );
                          },
                          child: new Text(
                            " - Resend email",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    if (state is LoginError) Text(state.error.message),
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
