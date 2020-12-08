import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/shared/bottom_nabar.dart';
import 'package:uniq/src/shared/constants.dart';

// TODO: Pass Board on route -> with parameter
class BoardDetailsPage extends StatelessWidget {
  Board board;

  BoardDetailsPage({Key key, this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(board.name),
      ),
      body: buildList(board),
      bottomNavigationBar: BottomNavbar(),
    );
  }

  Widget buildList(Board board) {
    List<String> photos = board.photos;
    // TODO: Na koncu dodać button ala img "dodaj pic" ;))
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: photos.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemBuilder: (BuildContext context, int index) {
          String photo = photos[index];
          String tag = '$photos/$index';
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
