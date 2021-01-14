import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/input_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class ChangeEmailPage extends StatefulWidget {
  final String email;
  const ChangeEmailPage({Key key, this.email}) : super(key: key);
  @override
  _ChangeEmailPage createState() => _ChangeEmailPage();
}

class _ChangeEmailPage extends State<ChangeEmailPage> {
  final emailController = new TextEditingController();
  //final emailController2 = new TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    //emailController2.dispose();
    super.dispose();
  }

  _changeEmail() {
    context.read<UserBloc>().add(UpdateEmail(email: emailController.text));
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
              if (state is UpdateEmailSuccess) {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(applicationPage));
              } else if (state is UpdateEmailError) {
                showToast(
                  "${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            builder: (BuildContext context, UserState state) {
              if (state is UpdateEmailLoading) {
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
                      /* 
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
                      */
                      SizedBox(height: size.height * 0.03),
                      UniqButton(
                        color: Theme.of(context).buttonColor,
                        push: () {
                          if (_NewPasswordKey.currentState.validate()) {
                            _changeEmail();
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
