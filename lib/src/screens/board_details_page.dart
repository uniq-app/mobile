import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';
import 'package:reorderables/reorderables.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/screens/moveable_stack.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:flutter/material.dart';
//import 'package:uniq/src/shared/components/reorderable_grid.dart';

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
                  // Todo: pass precached images
                  //child: StaggeredGrid(state.photos, snapshot.data),
                  child: GridPageView(state.photos, snapshot.data),
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

class GridPageView extends StatefulWidget {
  final List<Photo> photos;
  final List<Image> images;

  GridPageView(this.photos, this.images);
  @override
  _GridPageViewState createState() => _GridPageViewState(photos, images);
}

class _GridPageViewState extends State<GridPageView> {
  final List<Photo> photos;
  final List<Image> images;

  List<StaggeredTile> _listStaggeredTileExtended;
  List<Widget> _tiles = new List();

  _GridPageViewState(this.photos, this.images) {
    _listStaggeredTileExtended = [
      ...images.map((e) => StaggeredTile.count(1, 1)).toList()
    ];

    for (int i = 0; i < photos.length; i++) {
      _tiles.add(
          ReorderableTile(Key(UniqueKey().toString()), photos[i], images[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItemsView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          _tiles.insert(newIndex, _tiles.removeAt(oldIndex));
          _listStaggeredTileExtended.insert(
              newIndex, _listStaggeredTileExtended.removeAt(oldIndex));
        });
      },
      children: _tiles,
      crossAxisCount: 4,
      isGrid: true,
      staggeredTiles: _listStaggeredTileExtended,
      longPressToDrag: true,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      feedBackWidgetBuilder: (context, index, child) {
        return NewElementButton();
      },
    );
  }
}

class ReorderableTile extends StatelessWidget {
  Photo photo;
  Image image;
  ReorderableTile(Key key, this.photo, this.image) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String tag = '${photo.photoId}';
    String url = "${PhotoApiProvider.apiUrl}/${photo.value}";
    Map<String, dynamic> arguments = {'url': url, 'tag': tag, 'image': image};
    return PhotoHero(
        tag: tag,
        image: image,
        isRounded: true,
        onTap: () {
          Navigator.pushNamed(context, photoDetails, arguments: arguments);
        });
    ;
  }
}

class StaggeredGrid extends StatelessWidget {
  final List<Photo> photos;
  final List<Image> precachedImages;
  StaggeredGrid(this.photos, this.precachedImages);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: photos.length,
      itemBuilder: (BuildContext context, int index) {
        String tag = '${photos[index].photoId}';
        String url = "${PhotoApiProvider.apiUrl}/${photos[index].value}";
        Image image = precachedImages[index];
        Map<String, dynamic> arguments = {
          'url': url,
          'tag': tag,
          'image': image
        };

        /*
        return Draggable<Image>(
          feedback: SizedBox(
            height: 150,
            width: 150,
            child: image,
          ),
          data: image,
          child: image,
          childWhenDragging: image,
          onDragStarted: () => print("Started dragging"),
        );
        */
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
