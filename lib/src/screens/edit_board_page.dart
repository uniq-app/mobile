import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/form_field.dart';
import 'package:uniq/src/shared/utilities.dart';

class EditBoardPage extends StatefulWidget {
  final Board board;
  const EditBoardPage({Key key, this.board}) : super(key: key);
  @override
  _EditBoardPageState createState() => _EditBoardPageState();
}

class _EditBoardPageState extends State<EditBoardPage> {
  bool isPrivate = true;
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = new TextEditingController();
    final TextEditingController descriptionController =
        new TextEditingController();
    final TextEditingController tagController = new TextEditingController();
    final TextEditingController trueController = new TextEditingController();
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            Text(
              "Edit board",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text("Coverphoto"),
            UniqFormField(
              labelText: "Name",
              //controller: nameController,
              color: Theme.of(context).primaryColor,
              initialValue: widget.board.name,
            ),
            SizedBox(),
            UniqFormField(
              labelText: "Description",
              //controller: descriptionController,
              initialValue:
                  "Opis 1 roleresjnserb aervjserbsebt setbs etg sth srhr tghsrtghs sthrtghsrthse setghsetbs",
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Private"),
                Switch(
                  value: isPrivate,
                  onChanged: (value) {
                    setState(() {
                      isPrivate = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            Text("Background color"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Save")),
                FlatButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
