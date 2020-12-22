import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/ad_manager.dart';
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

  // Adds
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd
      ..load()
      ..show();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        print('Closes');
        break;
      default:
      // do nothing
    }
  }

  @override
  void initState() {
    super.initState();
    _isInterstitialAdReady = true;
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _interstitialAd?.dispose();
    super.dispose();
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

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  _loadBoards() async {
    context.read<BoardBloc>().add(FetchBoards());
  }

  showSelectBoardDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<BoardBloc, BoardState>(
          builder: (BuildContext context, BoardState state) {
            print("Rebuilded Dialog");
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
            return Center(
              child: Loading(),
            );
          },
        );
      });

  Widget buildDialog(List<Board> boards, List<Board> checked) {
    return AlertDialog(
      title: Text('Select boards'),
      content: SingleChildScrollView(
        child: Container(
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
                photoRepo.postAll(images, checked),
                // TODO: Wait for info Bloc -> loader -> sending?
                Navigator.of(context).pop()
              },
              child: Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}
