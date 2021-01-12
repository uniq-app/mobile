import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/screens/profile/edit_profile_page.dart';
import 'package:uniq/src/shared/constants.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  bool notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
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
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: EditProfilePage(),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Change password'),
              leading: Icon(Icons.lock, color: Colors.white),
              trailing: Icon(Icons.navigate_next, color: Colors.white),
              onTap: () => Navigator.of(context).pushNamed(newPasswordRoute),
            ),
            ListTile(
              title: Text('Change email'),
              leading: Icon(Icons.email, color: Colors.white),
              trailing: Icon(Icons.navigate_next, color: Colors.white),
              onTap: () =>
                  Navigator.of(context).pushNamed(changeEmailCodeRoute),
            ),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications, color: Colors.white),
              trailing: Switch(
                value: notificationsEnabled,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              onTap: () => print("Notifications"),
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
