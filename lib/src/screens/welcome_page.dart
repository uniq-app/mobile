import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: size.height * 0.4,
                child: SvgPicture.asset("assets/images/imagination.svg")),
            Text(
              "welcome to UNIQ",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            UniqButton(
              fontSize: 18,
              text: "login",
              color: Theme.of(context).primaryColor,
              push: () {
                Navigator.pushNamed(context, loginRoute);
              },
            ),
            UniqButton(
              fontSize: 18,
              text: "register",
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              push: () {
                Navigator.pushNamed(context, signupRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
