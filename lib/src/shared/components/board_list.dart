import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/board_list_element.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';
import 'package:uniq/src/shared/components/user_icon_button.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    context.read<PageCubit>().setPage(PageState.profilePage);
                  },
                ),
              ),
            )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return BoardListElement(
                board: boards[index],
                boardLink: () {
                  Navigator.pushNamed(context, boardDetailsRoute,
                      arguments: boards[index]);
                },
                editLink: () {
                  Navigator.pushNamed(context, editBoardPage,
                      arguments: boards[index]);
                },
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
