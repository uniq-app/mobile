import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.forward();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child: Container(
                height: size.height * 0.4,
                child: SvgPicture.asset(
                  "assets/images/imagination.svg",
                ),
              ),
            ),
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
            SizedBox(height: size.height * 0.02),
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
