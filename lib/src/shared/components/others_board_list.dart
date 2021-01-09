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
  List<Board> followedBoards;
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

  _loadFollowedBoards() {
    context.read<FollowedBoardsBloc>().add(GetFollowedBoards());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowedBoardsBloc, FollowedBoardsState>(
      listener: (context, FollowedBoardsState state) {
        if (state is FollowBoardSuccess) {
          _loadFollowedBoards();
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
        }
        if (state is UnfollowBoardSuccess) {
          _loadFollowedBoards();
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
      builder: (BuildContext context, FollowedBoardsState state) {
        if (state is GetFollowedBoardsSuccess)
          followedBoards = state.boardResults.results;
        print(followedBoards);
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext _, int index) {
              return BoardListElement(
                icon: Icon(
                  Icons.favorite,
                  color: _isFollowed(widget.boards[index])
                      ? Colors.red
                      : Colors.white,
                ),
                board: widget.boards[index],
                boardLink: () {
                  Navigator.pushNamed(context, boardDetailsRoute,
                      arguments: widget.boards[index]);
                },
                iconAction: () => _toggleFollow(context, widget.boards[index]),
              );
            },
            childCount: widget.boards.length,
          ),
        );
      },
    );
  }
}
