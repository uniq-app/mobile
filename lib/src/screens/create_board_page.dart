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
import 'package:uniq/src/shared/components/board_cover_settings.dart';
import 'package:uniq/src/shared/components/input_form_field.dart';
import 'package:uniq/src/shared/utilities.dart';

class CreateBoardPage extends StatefulWidget {
  const CreateBoardPage({Key key}) : super(key: key);

  @override
  _CreateBoardPageState createState() => _CreateBoardPageState();
}

class _CreateBoardPageState extends State<CreateBoardPage> {
  bool isPrivate = true;
  String boardCover,
      defaultBoardCover =
          "https://images.unsplash.com/photo-1567201864585-6baec9110dac?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=50";
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();

  Color tempColor = Colors.amber[700];
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  _createBoard() {
    File coverImage;
    Map<String, dynamic> boardData = new Map<String, dynamic>();
    boardData['name'] = nameController.text;
    boardData['description'] = descriptionController.text;
    boardData['isPrivate'] = isPrivate;
    boardData['isCreatorHidden'] = true;
    if (File(boardCover).exists() != null) {
      print("File exist");
      coverImage = File(boardCover);
      context.read<BoardBloc>().add(CreateBoard(
          board: Board.fromJson(boardData), coverImage: coverImage));
    } else {
      context.read<BoardBloc>().add(CreateBoard(
          board: Board.fromJson(boardData), coverLink: defaultBoardCover));
    }
  }

  Future _getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        boardCover = image.path;
        print(boardCover);
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

  final _CreateKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print(boardCover);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocListener<BoardBloc, BoardState>(
            listener: (context, state) {
              if (state is BoardCreated) {
                Navigator.pop(context);
                showToast(
                  "Board successfuly created!",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.green,
                );
              } else if (state is BoardsError) {
                showToast(
                  "Failed to create board - ${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _CreateKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Create board",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.05),
                  UniqInputField(
                    color: Theme.of(context).accentColor,
                    isObscure: false,
                    labelText: "Name",
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) return "Name cannot be empty";
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  UniqInputField(
                    color: Theme.of(context).accentColor,
                    isObscure: false,
                    labelText: "Description",
                    controller: descriptionController,
                    validator: (value) {
                      if (value.isEmpty) return "Description cannot be empty";
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  BoardCoverSettings(
                    image: boardCover ?? defaultBoardCover,
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
                          if (_CreateKey.currentState.validate()) {
                            _createBoard();
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
                      ),
                    ],
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
