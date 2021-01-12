import 'dart:io';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
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
  String boardCover;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();

  Color tempColor = Colors.amberAccent;
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  _deleteBoard() {
    context.read<BoardBloc>().add(DeleteBoard(boardId: widget.board.id));
    Navigator.pop(context);
  }

  _updateBoard() {
    File coverImage;
    if (boardCover != null) coverImage = File(boardCover);

    Map<String, dynamic> boardData = new Map<String, dynamic>();
    boardData['boardId'] = widget.board.id;
    boardData['name'] = nameController.text;
    boardData['description'] = descriptionController.text;
    boardData['isPrivate'] = isPrivate;

    context.read<BoardBloc>().add(
        UpdateBoard(board: Board.fromJson(boardData), coverImage: coverImage));
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
        boardCover = image.path;
        print(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<bool> colorPickerDialog(boardColor) async {
    return ColorPicker(
      color: boardColor,
      onColorChanged: (Color color) => setState(() => tempColor = color),
      width: 40,
      height: 40,
      borderRadius: 15,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 220,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: false,
      showColorName: false,
      showColorCode: false,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      constraints: const BoxConstraints(
          minHeight: 455, minWidth: 320, maxWidth: 320, maxHeight: 455),
    );
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
              } else if (state is DeleteError) {
                showToast(
                  "Failed to delete board - ${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
              if (state is BoardUpdated) {
                Navigator.pop(context);
                showToast(
                  "Board successfuly updated!",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.green,
                );
              } else if (state is UpdateError) {
                showToast(
                  "Failed to update board - ${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _EditKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "edit board",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        IconButton(
                            iconSize: 35,
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  child: DeleteAlert(
                                      deleteMessage:
                                          "Do you want to delete board called '" +
                                              widget.board.name +
                                              "'?",
                                      deleteAction: _deleteBoard));
                            })
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "Name",
                      controller: nameController,
                      maxLength: 20,
                      validator: (value) {
                        if (value.isEmpty) return 'Enter name of the board';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "Description",
                      controller: descriptionController,
                      maxLines: null,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Enter description of the board';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    if (boardCover != null)
                      BoardCoverSettings(
                        image: boardCover,
                        editLink: _getImage,
                      )
                    else if (widget.board.cover != '')
                      BoardCoverSettings(
                        image:
                            "${PhotoApiProvider.apiUrl}/thumbnail/${widget.board.cover}",
                        editLink: _getImage,
                      )
                    else
                      BoardCoverSettings(
                        editLink: _getImage,
                      ),

                    SizedBox(height: size.height * 0.02),
                    // todo: Change stateful to bloc
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: size.width * 0.9,
                          height: size.height * 0.07,
                          padding: EdgeInsets.only(left: 20),
                          color: tempColor,
                          child: Text("Change color",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300)),
                        ),
                        onTap: () async {
                          final Color colorBeforeDialog = tempColor;
                          if (!(await colorPickerDialog(tempColor))) {
                            setState(() {
                              tempColor = colorBeforeDialog;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Private",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w300)),
                        Checkbox(
                          value: isPrivate,
                          onChanged: (value) {
                            setState(() {
                              isPrivate = value;
                            });
                          },
                          activeColor: tempColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UniqButton(
                          screenWidth: 0.35,
                          screenHeight: 0.07,
                          color: tempColor,
                          push: () {
                            if (_EditKey.currentState.validate()) {
                              _updateBoard();
                            }
                          },
                          text: "Save",
                        ),
                        UniqButton(
                          screenWidth: 0.35,
                          screenHeight: 0.07,
                          color: Theme.of(context).accentColor,
                          push: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
