import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/followed_boards/followed_boards_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/shared/components/board_list_element.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OthersBoardList extends StatefulWidget {
  final List<Board> boards;
  OthersBoardList(this.boards);

  @override
  _OthersBoardListState createState() => _OthersBoardListState();
}

class _OthersBoardListState extends State<OthersBoardList> {
  List<Board> followedBoards = new List();
  @override
  void initState() {
    super.initState();
  }

  _isFollowed(Board board) {
    return followedBoards.contains(board);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _toggleFollow(BuildContext context, Board board) {
    BoardResults boardResults =
        BlocProvider.of<FollowedBoardsBloc>(context).boardResults;
    List<Board> results = boardResults?.results;
    (results.contains(board))
        ? _unfollow(context, board)
        : _follow(context, board);
  }

  _follow(BuildContext context, Board board) {
    BlocProvider.of<FollowedBoardsBloc>(context)
        .add(FollowBoard(boardId: board.id));
  }

  _unfollow(BuildContext context, Board board) {
    BlocProvider.of<FollowedBoardsBloc>(context)
        .add(UnfollowBoard(boardId: board.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FollowedBoardsBloc, FollowedBoardsState>(
      listener: (context, FollowedBoardsState state) {
        if (state is FollowBoardSuccess) {
          showToast(
            "Added to followed",
            position: ToastPosition.bottom,
            backgroundColor: Colors.green[400],
          );
        } else if (state is FollowBoardError) {
          showToast(
            "Couldn't follow board - ${state.error.message}",
            position: ToastPosition.bottom,
            backgroundColor: Colors.redAccent,
          );
        } else if (state is UnfollowBoardSuccess) {
          showToast(
            "Unfollow success",
            position: ToastPosition.bottom,
            backgroundColor: Colors.green[400],
          );
        } else if (state is FollowBoardError) {
          showToast(
            "Couldn't unfollow board - ${state.error.message}",
            position: ToastPosition.bottom,
            backgroundColor: Colors.redAccent,
          );
        }
      },
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext _, int index) {
            return BlocBuilder<FollowedBoardsBloc, FollowedBoardsState>(
              builder: (context, state) {
                if (state is GetFollowedBoardsSuccess) {
                  followedBoards = state.boardResults.results;
                }
                return BoardListElement(
                  icon: Icon(
                    Icons.favorite,
                    color: _isFollowed(widget.boards[index])
                        ? Colors.red
                        : Colors.white,
                  ),
                  board: widget.boards[index],
                  boardLink: () {
                    Navigator.pushNamed(context, nonEditableDetailsRoute,
                        arguments: widget.boards[index]);
                  },
                  iconSize: 35,
                  iconAction: () =>
                      _toggleFollow(context, widget.boards[index]),
                );
              },
            );
          },
          childCount: widget.boards.length,
        ),
      ),
    );
  }
}
