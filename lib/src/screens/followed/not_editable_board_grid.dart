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

class NotEditableBoardGridPage extends StatefulWidget {
  final Board board;

  NotEditableBoardGridPage({Key key, @required this.board}) : super(key: key);

  @override
  _NotEditableBoardGridPageState createState() =>
      _NotEditableBoardGridPageState(this.board);
}

class _NotEditableBoardGridPageState extends State<NotEditableBoardGridPage> {
  Board board;
  _NotEditableBoardGridPageState(this.board);

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Color darken(Color color, percent) {
    var f = 1 - percent / 100;
    return Color.fromARGB(color.alpha, (color.red * f).round(),
        (color.green * f).round(), (color.blue * f).round());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (board.extraData != '')
          ? HexColor.fromHex(board.extraData)
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: (board.extraData != '')
            ? darken(HexColor.fromHex(board.extraData), 15)
            : Theme.of(context).scaffoldBackgroundColor,
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
                //return StaggeredGrid(state.photos, snapshot.data);
                Size size = MediaQuery.of(context).size;
                return Grid(state.photos, snapshot.data, size);
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

class Grid extends StatefulWidget {
  final List<Photo> photos;
  final List<Image> precachedImages;
  final Size _size;

  Grid(this.photos, this.precachedImages, this._size);
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
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
    return Padding(
      padding: EdgeInsets.all(4),
      child: GridView.builder(
        itemCount: _tiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 4, mainAxisSpacing: 4, crossAxisCount: 3),
        itemBuilder: (context, index) {
          return GridTile(child: _tiles[index]);
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
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
