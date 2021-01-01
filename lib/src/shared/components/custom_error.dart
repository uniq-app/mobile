import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  final String message;
  final Function onTap;
  CustomError({this.message, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.headline6.fontSize),
          ),
        ),
      ),
    );
  }
}
