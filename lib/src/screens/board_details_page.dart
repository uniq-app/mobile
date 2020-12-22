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
import 'package:uniq/src/shared/bottom_nabar.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/custom_error.dart';
import 'package:uniq/src/shared/loading.dart';

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
      bottomNavigationBar: BottomNavbar(),
    );
  }

  _loadPhotos() async {
    context.read<PhotoBloc>().add(FetchBoardPhotos(boardId: board.id));
  }

  Future<List<Image>> _precacheImages(List<Photo> photos) async {
    String src = "${PhotoApiProvider.apiUrl}";
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
                  child: StaggeredGrid(state.photos),
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

class StaggeredGrid extends StatelessWidget {
  final List<Photo> photos;

  StaggeredGrid(this.photos);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: photos.length,
      itemBuilder: (BuildContext context, int index) {
        String tag = '${photos[index].photoId}';
        String photo = "${PhotoApiProvider.apiUrl}/${photos[index].value}";
        Map<String, dynamic> arguments = {
          'photo': photo,
          'tag': tag,
        };
        return PhotoHero(
            photo: photo,
            tag: tag,
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
