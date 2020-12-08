import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/shared/ad_manager.dart';
import 'package:uniq/src/shared/bottom_nabar.dart';
import 'package:uniq/src/shared/constants.dart';

// TODO: Pass Board on route -> with parameter
class BoardDetailsPage extends StatefulWidget {
  Board board;
  BoardDetailsPage({Key key, this.board}) : super(key: key);

  @override
  _BoardDetailsPageState createState() =>
      _BoardDetailsPageState(key: key, board: board);
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  Board board;
  _BoardDetailsPageState({Key key, this.board});
  // Banner ADD
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(board.name),
      ),
      body: SafeArea(
        child: buildList(board),
      ),
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
          Map<String, dynamic> arguments = {'photo': photo, 'tag': tag};
          return PhotoHero(
              photo: photo,
              tag: tag,
              onTap: () {
                Navigator.pushNamed(context, photoDetails,
                    arguments: arguments);
              });
        });
  }
}
