import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:uniq/src/shared/constants.dart';

class BoardDetailsPage extends StatefulWidget {
  final Board board;

  BoardDetailsPage({Key key, this.board}) : super(key: key);

  @override
  _BoardDetailsPageState createState() => _BoardDetailsPageState(this.board);
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  Board board;
  _BoardDetailsPageState(this.board);

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
    List<Image> images =
        photos.map((e) => Image.network("$src/${e.value}")).toList();
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
                return Padding(
                  padding: EdgeInsets.all(4),
                  // CASE 1
                  //child: StaggeredGrid(state.photos, snapshot.data),
                  // CASE 2
                  child: WrapGrid(state.photos, snapshot.data),
                );
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

  WrapGrid(this.photos, this.precachedImages);
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
        String tag = '${widget.photos[i].photoId}';
        String url = "${PhotoApiProvider.apiUrl}/${widget.photos[i].value}";
        Image image = widget.precachedImages[i];
        Map<String, dynamic> arguments = {
          'url': url,
          'tag': tag,
          'image': image
        };
        _tiles.add(
          SizedBox.fromSize(
            size: Size(100, 100),
            child: PhotoHero(
              tag: tag,
              image: image,
              isRounded: true,
              onTap: () {
                Navigator.pushNamed(context, photoDetails,
                    arguments: arguments);
              },
            ),
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

    return Center(
      child: ReorderableWrap(
        spacing: 8.0,
        runSpacing: 4.0,
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
      ),
    );
  }
}

/* 

class StaggeredGrid extends StatefulWidget {
  final List<Photo> photos;
  final List<Image> precachedImages;
  StaggeredGrid(this.photos, this.precachedImages);

  @override
  _StaggeredGridState createState() =>
      _StaggeredGridState(this.photos, this.precachedImages);
}

class _StaggeredGridState extends State<StaggeredGrid> {
  final List<Photo> _photos;
  final List<Image> _precachedImages;
  _StaggeredGridState(this._photos, this._precachedImages);
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: widget.photos.length,
      itemBuilder: (BuildContext context, int index) {
        String tag = '${widget.photos[index].photoId}';
        String url = "${PhotoApiProvider.apiUrl}/${widget.photos[index].value}";
        Image image = widget.precachedImages[index];
        Map<String, dynamic> arguments = {
          'url': url,
          'tag': tag,
          'image': image
        };
        return DragTarget<Image>(
          builder: (context, candidateData, rejectedData) {
            return LongPressDraggable<Image>(
              feedback: SizedBox(
                height: 50,
                width: 50,
                child: image,
              ),
              data: image,
              child: image,
              childWhenDragging: image,
            );
          },
          onAccept: (data) {
            print("Accepted target");
            setState(() {
              // Update index of photos and precachedImages
              int oldImageIndex = _precachedImages.indexOf(data);

              Photo oldPhoto = _photos.removeAt(oldImageIndex);
              Image oldImage = _precachedImages.removeAt(oldImageIndex);

              _photos.insert(index, oldPhoto);
              _precachedImages.insert(index, oldImage);
            });
          },
          onLeave: (data) {
            print("Leave data: $data");
          },
          onMove: (data) {
            print("Reached target");
          },
        );
        return PhotoHero(
            tag: tag,
            image: image,
            isRounded: true,
            onTap: () {
              Navigator.pushNamed(context, photoDetails, arguments: arguments);
            });
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}
*/
