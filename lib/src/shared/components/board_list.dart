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
  @override
  Widget build(BuildContext context) {
    return SliverList(
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
    );
  }
}
