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
import 'package:uniq/src/shared/components/uniq_alert.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

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

  Color tempColor = Color(0xffB65DC7);
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
      wheelDiameter: 210,
      heading: Text(
        'select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'select color shade',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      wheelSubheading: Text(
        'selected color and its shades',
        style: Theme.of(context).textTheme.subtitle2,
      ),

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
          minHeight: 460, minWidth: 320, maxWidth: 320, maxHeight: 460),
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
                  "${state.error.message}",
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
                  "${state.error.message}",
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
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        IconButton(
                            iconSize: 35,
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  child: UniqAlert(
                                      message:
                                          "Do you want to delete board called '" +
                                              widget.board.name +
                                              "'?",
                                      action: _deleteBoard));
                            })
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "name",
                      controller: nameController,
                      maxLength: 20,
                      validator: (value) {
                        if (value.isEmpty) return 'enter name of the board';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "description",
                      controller: descriptionController,
                      maxLines: null,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'enter description of the board';
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
                        filterColor: tempColor,
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
                          child: Text(
                            "change color",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
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

                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "private",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
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
                    SizedBox(height: size.height * 0.01),
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
                          text: "save",
                        ),
                        UniqButton(
                          screenWidth: 0.35,
                          screenHeight: 0.07,
                          color: Theme.of(context).accentColor,
                          push: () {
                            Navigator.pop(context);
                          },
                          text: "cancel",
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
