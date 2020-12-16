import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/photo.dart';
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
    bloc.getBoards("grachu");
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
            return BoardList(snapshot.data.results);
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
            Navigator.pushNamed(context, createBoardRoute);
          },
          child: Icon(Icons.add)),
      // TODO: Switch to proper icons and labels, "switch" screen without routing
      bottomNavigationBar: BottomNavbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class BoardList extends StatelessWidget {
  final List<Board> boards;
  BoardList(this.boards);

  @override
  Widget build(BuildContext context) {
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
              String image =
                  "https://images.unsplash.com/photo-1455582916367-25f75bfc6710?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60";
              return UniqBoardElement(
                  name: boards[index].name,
                  description: "Opis $index",
                  imageLink: image,
                  onTap: () {
                    Navigator.pushNamed(context, boardDetailsRoute,
                        arguments: boards[index]);
                  });
            },
            childCount: boards.length,
          ),
        ),
      ],
    );
  }
}
