import 'package:flutter/material.dart';

class ClickableAddSomething extends StatelessWidget {
  final Function onTap;
  ClickableAddSomething(this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.black26,
        child: Icon(Icons.add),
      ),
    );
  }
}
