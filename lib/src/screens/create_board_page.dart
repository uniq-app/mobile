import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/shared/utilities.dart';

class CreateBoardPage extends StatelessWidget {
  const CreateBoardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = new TextEditingController();
    final descriptionController = new TextEditingController();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).accentColor,
        child: Column(
          children: [
            Text(
              "Create new board",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text("Name"),
            UniqInputField(
              hintText: "Name",
              color: Theme.of(context).primaryColor,
            ),
            Text("Description"),
            UniqInputField(
              hintText: "Description",
              color: Theme.of(context).primaryColor,
            ),
            Text("Private"),
            UniqInputField(
              hintText: "Private",
              color: Theme.of(context).primaryColor,
            ),
            Text("Name"),
            UniqInputField(
              hintText: "Name",
              color: Theme.of(context).primaryColor,
            ),
            Text("Tags"),
          ],
        ),
      ),
    );
  }
}
