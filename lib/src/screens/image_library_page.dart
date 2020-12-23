import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/custom_error.dart';
import 'package:uniq/src/shared/loading.dart';

class ImageLibraryPage extends StatefulWidget {
  @override
  _ImageLibraryPageState createState() => new _ImageLibraryPageState();
}

class _ImageLibraryPageState extends State<ImageLibraryPage> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  PhotoRepository photoRepo = PhotoApiProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Pick images'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPressed,
        child: Icon(Icons.navigate_next),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Center(child: Text('Error: $_error')),
        Expanded(
          child: buildGridView(),
        ),
        RaisedButton(
          child: Text("Pick images"),
          onPressed: loadAssets,
        ),
      ],
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';
    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarTitle: "Library",
          allViewTitle: "All photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#FFFFFF",
          actionBarColor: Theme.of(context).primaryColor.toHexTriplet(),
          //lightStatusBar: true,
          statusBarColor: Theme.of(context).primaryColor.toHexTriplet(),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      _error = error;
    });
  }

  onFabPressed() async {
    if (images.length > 0) {
      bool result = await showSelectBoardDialog(context);
      await Future.delayed(Duration(seconds: 2));
      if (result == true) _closePostDialog();
    } else {
      //Todo: show toast that u need to pick some items first
      print(images.length);
    }
  }

  _loadBoards() async {
    context.read<BoardBloc>().add(FetchBoards());
  }

  _postAllPhotos(List<Board> checked) async {
    context
        .read<PhotoBloc>()
        .add(PostAllPhotos(images: images, checked: checked));
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
                onTap: _postAllPhotos(checked),
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
                _postAllPhotos(checked),
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
                    context.read<BoardBloc>().add(SelectBoard(board: e));
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

// Todo: move extension somewhere else?
extension ColorX on Color {
  String toHexTriplet() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
