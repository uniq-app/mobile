import 'package:flutter/material.dart';

class UserIconButton extends StatelessWidget {
  final Function push;
  final String imageLink;
  final Color color, textColor;
  final double radius, iconSize, margin, padding;
  const UserIconButton({
    Key key,
    this.push,
    this.color,
    this.textColor = Colors.white,
    this.radius = 10,
    this.iconSize = 0.2,
    this.margin = 10,
    this.padding = 20,
    this.imageLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FlatButton(
      onPressed: push,
      child: Container(
          width: 70,
          height: 70,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              border: Border.all(width: 2, color: Colors.white)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius - 6),
            child: Image.network(
              imageLink,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
