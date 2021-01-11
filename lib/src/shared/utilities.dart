import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/home/home_page.dart';

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

class DeleteAlert extends StatelessWidget {
  final String deleteMessage;
  final Function deleteAction;
  const DeleteAlert({Key key, this.deleteMessage, this.deleteAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmation"),
      content: Text(deleteMessage),
      actions: [
        FlatButton(
            color: Theme.of(context).accentColor,
            onPressed: deleteAction,
            child: Text("Yes")),
        FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No")),
      ],
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
    );
  }
}
