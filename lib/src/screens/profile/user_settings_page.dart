import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/screens/profile/edit_profile_page.dart';
import 'package:uniq/src/shared/components/settings_list_element.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  bool notificationsEnabled = false, changedNotificationSetting = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: size.height * 0.085,
        title: Text(
          'profile settings',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "profile settings",
            //   style: Theme.of(context).textTheme.headline5,
            // ),
            SizedBox(height: size.height * 0.01),
            Container(
              height: size.height * 0.3,
              child: SvgPicture.asset("assets/images/settings.svg"),
            ),
            SizedBox(height: size.height * 0.03),

            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                child: Column(
                  children: [
                    UniqListElement(
                      text: 'edit profile',
                      color: Theme.of(context).buttonColor,
                      prefixWidget: Icon(Icons.person, color: Colors.white),
                      suffixWidget:
                          Icon(Icons.navigate_next, color: Colors.white),
                      push: () =>
                          Navigator.of(context).pushNamed(editProfileRoute),
                    ),
                    UniqListElement(
                      text: 'change password',
                      color: Theme.of(context).buttonColor,
                      prefixWidget: Icon(Icons.lock, color: Colors.white),
                      suffixWidget:
                          Icon(Icons.navigate_next, color: Colors.white),
                      push: () =>
                          Navigator.of(context).pushNamed(newPasswordRoute),
                    ),
                    UniqListElement(
                      text: 'change email',
                      color: Theme.of(context).buttonColor,
                      prefixWidget: Icon(Icons.email, color: Colors.white),
                      suffixWidget:
                          Icon(Icons.navigate_next, color: Colors.white),
                      push: () =>
                          Navigator.of(context).pushNamed(changeEmailCodeRoute),
                    ),
                    UniqListElement(
                      text: 'notifications',
                      color: Theme.of(context).buttonColor,
                      prefixWidget:
                          Icon(Icons.notifications, color: Colors.white),
                      suffixWidget: Switch(
                        value: notificationsEnabled,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          setState(() {
                            if (changedNotificationSetting) {
                              changedNotificationSetting = false;
                            } else
                              changedNotificationSetting = true;
                            notificationsEnabled = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            _logout(context),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Theme.of(context).buttonColor,
            child: FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      child: DeleteAlert(
                          deleteMessage: "Are you sure to log out?",
                          deleteAction: _sendLogout));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent),
                    Text(
                      " logout",
                      style: TextStyle(color: Colors.redAccent, fontSize: 18),
                    ),
                  ],
                )),
          ),
        ));
  }
}
