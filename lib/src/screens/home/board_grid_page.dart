import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/grid_element.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:reorderables/reorderables.dart';

class BoardGridPage extends StatefulWidget {
  final Board board;

  BoardGridPage({Key key, @required this.board}) : super(key: key);

  @override
  _BoardGridPageState createState() => _BoardGridPageState(this.board);
}

class _BoardGridPageState extends State<BoardGridPage> {
  Board board;
  _BoardGridPageState(this.board);

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.board.name),
      ),
      body: _body(),
    );
  }

  _loadPhotos() async {
    context.read<PhotoBloc>().add(FetchBoardPhotos(boardId: board.id));
  }

  Future<List<Image>> _precacheImages(List<Photo> photos) async {
    String src = "${PhotoApiProvider.apiUrl}/thumbnail";
    List<Image> images = photos
        .map((e) => Image.network(
              "$src/${e.value}",
              fit: BoxFit.contain,
            ))
        .toList();
    var futures =
        images.map((element) => precacheImage(element.image, context));
    await Future.wait(futures);
    return images;
  }

  Widget _body() {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (BuildContext context, PhotoState state) {
        if (state is PhotosError) {
          final error = state.error;
          return CustomError(
            message: '${error.message}.\nTap to retry.',
            onTap: _loadPhotos,
          );
        } else if (state is PhotosLoaded) {
          // Future Builder
          return FutureBuilder(
            future: _precacheImages(state.photos),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Size size = MediaQuery.of(context).size;
                return WrapGrid(state.photos, snapshot.data, size);
              } else if (snapshot.hasError) {
                return CustomError(message: "Couldnt preload images");
              }
              return Loading();
            },
          );
        }
        return Center(
          child: Loading(),
        );
      },
    );
  }
}

class WrapGrid extends StatefulWidget {
  final List<Photo> photos;
  final List<Image> precachedImages;
  final Size _size;

  WrapGrid(this.photos, this.precachedImages, this._size);
  @override
  _WrapGridState createState() => _WrapGridState();
}

class _WrapGridState extends State<WrapGrid> {
  List<Widget> _tiles = new List();

  @override
  void initState() {
    super.initState();
    _createTilesFromImages();
  }

  _createTilesFromImages() {
    for (int i = 0; i < widget.precachedImages.length; i++) {
      if (widget.photos[i] != null) {
        _tiles.add(
          GridElement(
            width: widget._size.width * 0.3,
            photo: widget.photos[i],
            image: widget.precachedImages[i],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }

    return ReorderableWrap(
      spacing: 2.0,
      runSpacing: 2.0,
      padding: const EdgeInsets.all(8),
      children: _tiles,
      onReorder: _onReorder,
      onNoReorder: (int index) {
        //this callback is optional
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
      },
      onReorderStarted: (int index) {
        //this callback is optional
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
      },
    );
  }
}
