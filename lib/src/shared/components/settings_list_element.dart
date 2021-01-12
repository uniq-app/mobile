import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/home/home_page.dart';

class UniqListElement extends StatelessWidget {
  final String text;
  final Function push;
  final Color color, textColor;
  final double screenWidth, screenHeight, padding, fontSize;
  final Widget prefixWidget, suffixWidget;
  const UniqListElement({
    Key key,
    this.text,
    this.push,
    this.color,
    this.textColor = Colors.white,
    this.screenWidth = 1,
    this.screenHeight = 0.07,
    this.padding = 5,
    this.fontSize = 18,
    this.prefixWidget,
    this.suffixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * screenWidth,
      height: size.height * screenHeight,
      color: color,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
        leading: prefixWidget,
        trailing: suffixWidget,
        onTap: push,
      ),
    );
  }
}
