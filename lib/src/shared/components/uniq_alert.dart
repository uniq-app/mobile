import 'package:flutter/material.dart';

class UniqAlert extends StatelessWidget {
  final String message;
  final Function action;
  const UniqAlert({Key key, this.message, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmation"),
      content: Text(message),
      actions: [
        FlatButton(
            color: Theme.of(context).accentColor,
            onPressed: action,
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
