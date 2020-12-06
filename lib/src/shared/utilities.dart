import 'package:flutter/material.dart';
import 'constants.dart';

class UniqButton extends StatelessWidget {
  final String text;
  final Function push;
  final Color color, textColor;
  const UniqButton({
    Key key,
    this.text,
    this.push,
    this.color = primaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20),
          color: color,
          onPressed: push,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class UniqInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final String hintText;
  const UniqInputField({
    Key key,
    this.onChanged,
    this.isObscure,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(
        obscureText: isObscure,
        onChanged: onChanged,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
