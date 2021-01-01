import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  File _image;
  File get image => _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print("Picked");

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      bool result = await showSelectBoardDialog(context);
      await Future.delayed(Duration(seconds: 2));
      if (result == true) _closePostDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a photo.'),
      ),
      body: Center(
        child: _image == null ? Text('No image.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Take Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  _loadBoards() async {
    context.read<BoardBloc>().add(FetchBoards());
  }

  _postImage(List<Board> checked) async {
    context
        .read<PhotoBloc>()
        .add(PostSingleImage(image: image, checked: checked));
  }

  _closePostDialog() async {
    context.read<PhotoBloc>().add(ClosePostDialog());
  }

  Future showSelectBoardDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        // Get board state
        return BlocBuilder<BoardBloc, BoardState>(
          builder: (BuildContext context, BoardState state) {
            print("Rebuilded Dialog (board)");
            if (state is BoardsError) {
              final error = state.error;
              return CustomError(
                message: '${error.message}.\nTap to retry.',
                onTap: _loadBoards,
              );
            } else if (state is BoardsLoaded) {
              List<Board> boards = state.boardResults.results;
              List<Board> checked = state.checked;
              return buildDialog(boards, checked);
            }
            return Loading();
          },
        );
      });

  Widget buildDialog(List<Board> boards, List<Board> checked) {
    return AlertDialog(
      title: Text('Select boards'),
      content: SingleChildScrollView(
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (BuildContext context, PhotoState state) {
            print("Rebuilded dialog (photo)");
            if (state is PhotosError) {
              final error = state.error;
              return CustomError(
                message: '${error.message}.\nTap to retry.',
                onTap: _postImage(checked),
              );
            } else if (state is PhotoInitial) {
              return _dialogContainer(boards, checked);
            } else if (state is PhotosPostedSuccess) {
              Navigator.pop(context, true);
            }
            return Loading();
          },
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go back'),
            ),
            FlatButton(
              onPressed: () => {
                // Send to backend
                _postImage(checked),
              },
              child: Text('Add'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dialogContainer(List<Board> boards, List<Board> checked) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...boards
              .map(
                (e) => CheckboxListTile(
                  title: Text(e.name),
                  onChanged: (value) {
                    //context.read<BoardBloc>().add(SelectBoard(board: e));
                  },
                  value: checked.contains(e),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
