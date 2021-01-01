import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/shared/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBoardPage extends StatefulWidget {
  const CreateBoardPage({Key key}) : super(key: key);

  @override
  _CreateBoardPageState createState() => _CreateBoardPageState();
}

class _CreateBoardPageState extends State<CreateBoardPage> {
  _sampleBoard() {
    return '''
    {
  "cover": {
    "photo_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "value": "string"
  },
  "description": "Fajne psiutki",
  "isCreatorHidden": true,
  "isPrivate": true,
  "name": "Psiutki"
}
    ''';
  }

  _createBoard() {
    context.read<BoardBloc>().add(CreateBoard());
  }

  @override
  Widget build(BuildContext context) {
    final nameController = new TextEditingController();
    final descriptionController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("New board")),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
            // Todo: Switch this button to sth else, OutlinedButton for now
            OutlinedButton(
              onPressed: _createBoard,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
