import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/components/board_cover_settings.dart';
import 'package:uniq/src/shared/components/input_form_field.dart';
import 'package:uniq/src/shared/utilities.dart';

class EditBoardPage extends StatefulWidget {
  final Board board;
  const EditBoardPage({Key key, this.board}) : super(key: key);
  @override
  _EditBoardPageState createState() => _EditBoardPageState();
}

class _EditBoardPageState extends State<EditBoardPage> {
  bool got = false, isPrivate;
  File _boardCover;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  final TextEditingController privateController = new TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    privateController.dispose();
    super.dispose();
  }

  _deleteBoard() {
    context.read<BoardBloc>().add(DeleteBoard(boardId: widget.board.id));
    Navigator.pop(context);
  }

  _getStatus() {
    if (this.got != true) {
      nameController.text = widget.board.name;
      descriptionController.text = widget.board.description;
      this.isPrivate = widget.board.isPrivate;
      this.got = true;
    }
  }

  Future _getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _boardCover = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final _EditKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _getStatus();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocListener<BoardBloc, BoardState>(
            listener: (context, state) {
              if (state is BoardDeleted) {
                showToast(
                  "Successfuly deleted ${widget.board.name}!",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.greenAccent,
                );
                Navigator.pop(context);
              } else if (state is BoardsError) {
                showToast(
                  "Failed to delete board - ${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _EditKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit board",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      IconButton(
                          iconSize: 35,
                          icon: Icon(Icons.highlight_remove),
                          onPressed: () {
                            showDialog(
                                context: context,
                                child: DeleteAlert(
                                    board: widget.board,
                                    deleteAction: _deleteBoard));
                          })
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  UniqInputField(
                    color: Theme.of(context).accentColor,
                    isObscure: false,
                    labelText: "Name",
                    controller: nameController,
                  ),
                  SizedBox(height: size.height * 0.02),
                  UniqInputField(
                    color: Theme.of(context).accentColor,
                    isObscure: false,
                    labelText: "Description",
                    controller: descriptionController,
                  ),
                  SizedBox(height: size.height * 0.02),
                  BoardCoverSettings(
                    image: widget.board.cover.value,
                  ),
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
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {},
                    child: const Text('Color'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
