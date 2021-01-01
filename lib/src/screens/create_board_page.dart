import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/cover.dart';
import 'package:uniq/src/shared/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBoardPage extends StatefulWidget {
  const CreateBoardPage({Key key}) : super(key: key);

  @override
  _CreateBoardPageState createState() => _CreateBoardPageState();
}

class _CreateBoardPageState extends State<CreateBoardPage> {
  Board _sampleBoard() {
    Map<String, dynamic> boardData = new Map<String, dynamic>();
    Map<String, dynamic> coverData = new Map<String, dynamic>();
    boardData['name'] = "name ;)";
    boardData['description'] = "Description";
    boardData['isPrivate'] = true;
    boardData['isCreatorHidden'] = true;
    coverData['value'] =
        "https://fajnepodroze.pl/wp-content/uploads/2020/06/Welsh-Corgi-Pembroke.jpg";
    boardData['cover'] = coverData;
    return Board.fromJson(boardData);
  }

  _createBoard() {
    context.read<BoardBloc>().add(CreateBoard(board: _sampleBoard()));
  }

  @override
  Widget build(BuildContext context) {
    final nameController = new TextEditingController();
    final descriptionController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("New board")),
      body: BlocListener<BoardBloc, BoardState>(
        listener: (BuildContext context, BoardState state) {
          if (state is BoardCreated) {
            Navigator.pop(context);
          }
        },
        child: Container(
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
      ),
    );
  }
}
