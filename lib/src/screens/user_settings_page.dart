import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Your settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            SizedBox(height: size.height * 0.05),
            UniqButton(
              text: "DUPA",
              color: Theme.of(context).primaryColor,
              push: () {},
            ),
            UniqButton(
              text: "DWIE",
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              push: () {},
            ),
            UniqButton(
              text: "Save",
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              push: () {},
            ),
            UniqButton(
              text: "Cancell",
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              push: () {},
            ),
            _logout(context)
          ],
        ),
      ),
    );
  }

  _sendLogout() async {
    context.read<AuthBloc>().add(Logout());
  }

  Widget _logout(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is LogoutSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              welcomeRoute, (Route<dynamic> route) => false);
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _sendLogout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
