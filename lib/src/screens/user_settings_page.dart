import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
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
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Edit profile'),
              leading: Icon(Icons.person, color: Colors.white),
              trailing: Icon(Icons.navigate_next, color: Colors.white),
              onTap: () => print("Edit profile"),
            ),
            ListTile(
              title: Text('Change password'),
              leading: Icon(Icons.lock, color: Colors.white),
              trailing: Icon(Icons.navigate_next, color: Colors.white),
              onTap: () => print("Change password"),
            ),
            ListTile(
              title: Text('Change email'),
              leading: Icon(Icons.email, color: Colors.white),
              trailing: Icon(Icons.navigate_next, color: Colors.white),
              onTap: () => print("Change email"),
            ),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications, color: Colors.white),
              trailing: Icon(Icons.navigate_next, color: Colors.white),
              onTap: () => print("Notifications"),
            ),
            ListTile(
              title: Text(
                'Delete account',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
              leading: Icon(Icons.delete_forever, color: Theme.of(context).errorColor),
              onTap: () => print("Delete account"),
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
      child: ListTile(
        title: Text('Logout'),
        leading: Icon(Icons.logout, color: Colors.white),
        onTap: _sendLogout,
      ),
    );
  }
}
