import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/shared/components/loading.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        if (state is ResendCodeSuccess) {
          // TODO: Grachu check ,my inglisz
          showToast(
            "Code has been send to your email",
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
        body: Column(
          children: [
            Center(
              child: Text("We no dziabnij forma"),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, UserState state) {
                if (state is ResendCodeLoading) {
                  return Loading();
                }
                return OutlineButton(
                  onPressed: _sendNewCode,
                  child: Text('Send code'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
