import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/board_list_element.dart';
import 'package:uniq/src/shared/constants.dart';

class BoardList extends StatelessWidget {
  final List<Board> boards;
  final Icon icon;
  final double iconSize;
  BoardList(this.boards, this.icon, this.iconSize);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return BoardListElement(
            icon: icon,
            iconSize: iconSize,
            board: boards[index],
            filterColor: boards[index].extraData == ''
                ? Colors.grey
                : HexColor.fromHex(boards[index].extraData),
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

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
