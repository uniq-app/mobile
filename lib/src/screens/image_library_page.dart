import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/services/select_board_dialog_service.dart';

class ImageLibraryPage extends StatefulWidget {
  @override
  _ImageLibraryPageState createState() => new _ImageLibraryPageState();
}

class _ImageLibraryPageState extends State<ImageLibraryPage> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  PhotoRepository photoRepo = PhotoApiProvider();
  SelectBoardDialogService dialogService;

  @override
  void initState() {
    super.initState();
    dialogService = new SelectBoardDialogService(
        context: context, onSubmit: _postAllPhotos);
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
      bool result = await dialogService.showCustomDialog();
      await Future.delayed(Duration(seconds: 2));
      if (result == true) _closePostDialog();
    } else {
      //Todo: show toast that u need to pick some items first
      print(images.length);
    }
  }

  _postAllPhotos() async {
    // Read checked cubit then pass to function
    var res = await context.read<BoardBloc>().checked;
    print("res $res");
    context.read<PhotoBloc>().add(PostAllPhotos(images: images, checked: res));
  }

  _loadBoards() async {
    context.read<BoardBloc>().add(FetchBoards());
  }

  _closePostDialog() async {
    context.read<PhotoBloc>().add(ClosePostDialog());
  }
}

// Todo: move extension somewhere else?
extension ColorX on Color {
  String toHexTriplet() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
