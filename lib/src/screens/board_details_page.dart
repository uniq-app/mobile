import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/bottom_nabar.dart';
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
    // TODO:  super.init poczatek czy koniec?
    bloc.getPhotos(this.board.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.board.name),
      ),
      body: StreamBuilder(
        stream: bloc.photos,
        builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.all(10),
              child: StaggeredGrid(snapshot.data),
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
      ),
      bottomNavigationBar: BottomNavbar(),
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
