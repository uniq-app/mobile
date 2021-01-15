import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/notification/notification_bloc.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/models/profile_details.dart';
import 'package:uniq/src/screens/profile/edit_profile_page.dart';
import 'package:uniq/src/shared/components/settings_list_element.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/uniq_alert.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  bool notificationsEnabled;
  ProfileDetails profileDetails;
  @override
  void initState() {
    super.initState();
    _getUserProfileDetails();
  }

  _getUserProfileDetails() {
    profileDetails = context.read<ProfileBloc>().profileDetails;
    notificationsEnabled = profileDetails.notificationsEnabled;
  }

  _toggleNotifications() {
    print("Notifications: $notificationsEnabled");
    context
        .read<NotificationBloc>()
        .add(UpdateFcm(isEnabled: notificationsEnabled));
  }

  _reloadDetails() {
    context.read<ProfileBloc>().add(GetProfileDetails());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  welcomeRoute, (Route<dynamic> route) => false);
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, UserState state) {
            if (state is GetCodeSuccess) {
            } else if (state is GetCodeError) {
              showToast(
                "${state.error.message}",
                position: ToastPosition.bottom,
                backgroundColor: Colors.redAccent,
              );
            }
          },
        ),
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, NotificationState state) {
            if (state is UpdateFcmSuccess) {
              _reloadDetails();
            } else if (state is UpdateFcmError) {
              showToast(
                "${state.error.message}",
                position: ToastPosition.bottom,
                backgroundColor: Colors.redAccent,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "profile settings",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
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
                        text: 'edit name',
                        color: Theme.of(context).buttonColor,
                        prefixWidget: Icon(Icons.person, color: Colors.white),
                        suffixWidget:
                            Icon(Icons.navigate_next, color: Colors.white),
                        push: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ProfileBloc>(),
                              child: EditProfilePage(
                                username: profileDetails.username,
                              ),
                            ),
                          ),
                        ),
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
                        push: _getCode,
                      ),
                      UniqListElement(
                        text: 'notifications',
                        color: Theme.of(context).buttonColor,
                        prefixWidget:
                            Icon(Icons.notifications, color: Colors.white),
                        suffixWidget: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, ProfileState state) {
                            if (state is GetProfileDetailsSuccess) {
                              notificationsEnabled =
                                  state.profile.notificationsEnabled;
                            }
                            return Switch(
                              value: notificationsEnabled,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (value) {
                                notificationsEnabled = !notificationsEnabled;
                                _toggleNotifications();
                              },
                            );
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
      ),
    );
  }

  _sendLogout() async {
    context.read<AuthBloc>().add(Logout());
  }

  Widget _logout(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Theme.of(context).buttonColor,
        child: FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  child: UniqAlert(
                      message: "Are you sure to log out?",
                      action: _sendLogout));
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
    );
  }
}
