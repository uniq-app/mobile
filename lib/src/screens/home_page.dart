import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';
import 'package:uniq/src/shared/components/board_list_element.dart';
import 'package:uniq/src/shared/components/bottom_navbar.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/user_icon_button.dart';

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
    return _body();
  }

  Widget _body() {
    return BlocConsumer<BoardBloc, BoardState>(
      listener: (BuildContext context, BoardState state) {
        if (state is BoardCreated || state is BoardDeleted) {
          _loadBoards();
        }
      },
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
          return BoardListElement(
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
  final String userName = "Zdzisław";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            floating: true,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 15, bottom: 15),
              title: Text('Welcome $userName'),
              background: Container(
                alignment: Alignment.centerRight,
                width: size.width * 0.9,
                child: UserIconButton(
                  iconSize: 1.0,
                  radius: 30,
                  imageLink:
                      "https://images.unsplash.com/photo-1491555103944-7c647fd857e6?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
                  color: Colors.white,
                  margin: 20,
                  push: () {
                    Navigator.pushNamed(context, userSettingsRoute);
                  },
                ),
              ),
            )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return BoardListElement(
                name: boards[index].name,
                description: boards[index].description,
                imageLink: boards[index].cover.value,
                boardLink: () {
                  Navigator.pushNamed(context, boardDetailsRoute,
                      arguments: boards[index]);
                },
                editLink: () {
                  Navigator.pushNamed(context, editBoardPage,
                      arguments: boards[index]);
                },
                //Navigator.pushNamed(context, boardDetailsRoute,
                //arguments: boards[index]);
              );
            },
            childCount: boards.length,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            NewElementButton(
              heightFraction: 0.15,
              widthFraction: 0.8,
              push: () {
                Navigator.pushNamed(context, createBoardPage);
              },
            ),
          ]),
        ),
      ],
    );
  }
}
