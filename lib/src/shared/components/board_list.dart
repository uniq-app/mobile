import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/board_list_element.dart';
import 'package:uniq/src/shared/constants.dart';

class BoardList extends StatelessWidget {
  final List<Board> boards;
  final Icon icon;
  BoardList(this.boards, this.icon);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return BoardListElement(
            icon: icon,
            board: boards[index],
            boardLink: () {
              Navigator.pushNamed(context, boardDetailsRoute,
                  arguments: boards[index]);
            },
            iconAction: () {
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
