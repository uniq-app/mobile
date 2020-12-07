import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/shared/ad_manager.dart';
import 'package:uniq/src/shared/constants.dart';

// TODO: Pass Board on route -> with parameter
class BoardDetailsPage extends StatefulWidget {
  @override
  _BoardDetailsPageState createState() => _BoardDetailsPageState();
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  // Banner ADD
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
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
    bloc.getBoards("123");
    return Scaffold(
      appBar: AppBar(
        title: Text("Uniq"),
      ),
      // TODO: Stream builder
      body: StreamBuilder(
        stream: bloc.boardResults,
        builder: (context, AsyncSnapshot<BoardResults> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Route',
        child: Icon(Icons.navigate_before),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<BoardResults> snapshot) {
    List<String> photos = snapshot.data.results[0].photos;
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
