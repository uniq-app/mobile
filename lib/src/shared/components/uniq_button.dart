import 'package:flutter/material.dart';

class UniqButton extends StatelessWidget {
  final String text;
  final Function push;
  final Color color, textColor;
  final double radius, screenWidth, screenHeight, padding, fontSize;
  const UniqButton({
    Key key,
    this.text,
    this.push,
    this.color,
    this.textColor = Colors.white,
    this.radius = 15,
    this.screenWidth = 1,
    this.screenHeight = 0.07,
    this.padding = 5,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * screenWidth,
      height: size.height * screenHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: padding),
          color: color,
          onPressed: push,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
