import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/notifiers/dialog_state.dart';
import 'package:uniq/src/services/photo_api_provider.dart';

class ImageLibraryPage extends StatefulWidget {
  @override
  _ImageLibraryPageState createState() => new _ImageLibraryPageState();
}

class _ImageLibraryPageState extends State<ImageLibraryPage> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Pick images'),
      ),
      body: Column(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showSelectBoardDialog(context),
        child: Icon(Icons.navigate_next),
      ),
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
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarTitle: "Library",
          allViewTitle: "All photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  showSelectBoardDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        bloc.getBoards("123");
        return StreamBuilder(
          stream: bloc.boardResults,
          builder: (context, AsyncSnapshot<BoardResults> snapshot) {
            if (snapshot.hasData) {
              PhotoApiProvider apiProvider = PhotoApiProvider();
              return ChangeNotifierProvider<DialogState>(
                create: (context) =>
                    DialogState.fromStream(snapshot.data.results),
                child: Consumer<DialogState>(
                  builder: (context, _dialogState, _) => AlertDialog(
                    title: Text('Select boards'),
                    content: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ..._dialogState.boards
                                .map(
                                  (e) => CheckboxListTile(
                                    title: Text(e.name),
                                    onChanged: (value) {
                                      _dialogState.toggleChecked(e);
                                    },
                                    value: _dialogState.isChecked(e),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Go back'),
                          ),
                          FlatButton(
                            onPressed: () => {
                              // Send to backend
                              apiProvider.postAll(images, _dialogState),
                              Navigator.of(context).pop()
                            },
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      });
}
