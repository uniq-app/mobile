import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/shared/bottom_navbar.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/custom_error.dart';
import 'package:uniq/src/shared/loading.dart';
import 'package:uniq/src/shared/utilities.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    print("In home page init");
    _loadBoards();
  }

  _loadBoards() async {
    context.read<BoardBloc>().add(FetchBoards());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      //  floatingActionButton:
      //      FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
      bottomNavigationBar: BottomNavbar(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _body() {
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (BuildContext context, BoardState state) {
        if (state is BoardsError) {
          final error = state.error;
          return CustomError(
            message: '${error.message}.\nTap to retry.',
            onTap: _loadBoards,
          );
        } else if (state is BoardsLoaded) {
          return BoardList(state.boardResults.results);
        }
        return Center(
          child: Loading(),
        );
      },
    );
  }

  Widget buildList(BoardResults boardResults) {
    List<Board> boards = boardResults.results;
    return SafeArea(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: boards.length,
        itemBuilder: (BuildContext context, int index) {
          String name = boards[index].name;
          return UniqBoardElement(
              name: name,
              boardLink: () {
                Navigator.pushNamed(context, boardDetailsRoute,
                    arguments: boards[index]);
              });
        },
      ),
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
                  description:
                      "Opis $index Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  imageLink: image,
                  boardLink: () {
                    Navigator.pushNamed(context, boardDetailsRoute,
                        arguments: boards[index]);
                  },
                  editLink: () {
                    Navigator.pushNamed(context, boardDetailsRoute,
                        arguments: boards[index]);
                  },
                  deleteLink: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteAlert(board: boards[index]),
                    );
                    //Navigator.pushNamed(context, boardDetailsRoute,
                    //arguments: boards[index]);
                  });
            },
            childCount: boards.length,
          ),
        ),
      ],
    );
  }
}
