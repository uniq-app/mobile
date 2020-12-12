import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/screens/photo_hero.dart';
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
    super.initState();
    bloc.getPhotos(this.board.id);
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
            return buildList(snapshot.data);
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

  Widget buildList(List<Photo> photos) {
    // TODO: Na koncu dodać button ala img "dodaj pic" ;))
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: photos.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemBuilder: (BuildContext context, int index) {
          String tag = '${photos[index].photoId}';
          String photo =
              "http://192.168.43.223:80/images/${photos[index].value}";
          Map<String, dynamic> arguments = {
            'photo': photo,
            'tag': tag,
            'boxFit': BoxFit.contain
          };
          return PhotoHero(
              photo: photo,
              tag: tag,
              boxFit: BoxFit.cover,
              onTap: () {
                Navigator.pushNamed(context, photoDetails,
                    arguments: arguments);
              });
        });
  }
}
