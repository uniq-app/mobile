import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/shared/bottom_nabar.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print("Board init");
    bloc.getBoards("1");
    super.initState();
  }

  @override
  void dispose() {
    print("Board destroy");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
      // TODO: Switch to proper icons and labels, "switch" screen without routing
      bottomNavigationBar: BottomNavbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildList(AsyncSnapshot<BoardResults> snapshot) {
    List<Board> boards = snapshot.data.results;
    return SafeArea(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: boards.length,
        itemBuilder: (BuildContext context, int index) {
          String name = boards[index].name;
          return UniqBoardElement(
              name: name,
              onTap: () {
                Navigator.pushNamed(context, boardDetailsRoute,
                    arguments: boards[index]);
              });
        },
      ),
    );
  }
}

Widget placeholderList() {
  var imagesArray = [
    "https://images.unsplash.com/photo-1455582916367-25f75bfc6710?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1526241671692-e7d3195c9531?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8M3x8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1488875482628-eee706cbfad5?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8N3x8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1499018658500-b21c72d7172b?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NXx8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1590101490234-780fb118bd84?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHw%3D&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1485841938031-1bf81239b815?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Nnx8fGVufDB8fHw%3D&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTF8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1569574229209-e8d6463fa1c8?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTJ8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1480247439002-7a2d7f3be28b?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTR8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1498814117408-e396f5507073?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTZ8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1563866769937-28619344db65?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTd8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1563866769937-28619344db65?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTd8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1563866769937-28619344db65?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTd8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1563866769937-28619344db65?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTd8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1563866769937-28619344db65?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTd8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1563866769937-28619344db65?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTd8fHxlbnwwfHx8&auto=format&fit=crop&w=900&q=60"
  ];
  return CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
          pinned: false,
          floating: true,
          expandedHeight: 120.0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsetsDirectional.only(start: 15, bottom: 15),
            title: Text('Your boards'),
            background: Image.asset(
              'assets/hello.jpg',
              fit: BoxFit.cover,
            ),
          )),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            print(imagesArray[index]);
            return UniqBoardElement(
              name: "Nazwa $index",
              description: "Opis $index",
              imageLink: imagesArray[0],
            );
          },
          childCount: 8,
        ),
      ),
    ],
  );
}
