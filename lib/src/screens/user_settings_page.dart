import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class UserSettingsPage extends StatelessWidget {
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
      ],
    )));
  }
}
