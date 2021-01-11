import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/followed_boards/followed_boards_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/followed/search_page.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/others_board_list.dart';
import 'package:uniq/src/shared/constants.dart';

class FollowedBoards extends StatefulWidget {
  @override
  _FollowedBoardsState createState() => _FollowedBoardsState();
}

class _FollowedBoardsState extends State<FollowedBoards> {
  @override
  void initState() {
    super.initState();
    if (_getInitFollowedBoardsState() is FollowedBoardsInitial) {
      _loadFollowedBoards();
    }
  }

  _getInitFollowedBoardsState() {
    return context.read<FollowedBoardsBloc>().state;
  }

  _loadFollowedBoards() {
    context.read<FollowedBoardsBloc>().add(GetFollowedBoards());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Text("Followed boards"),
          ),
          BlocConsumer<FollowedBoardsBloc, FollowedBoardsState>(
            listener: (context, state) {
              if (state is FollowBoardSuccess ||
                  state is UnfollowBoardSuccess) {
                _loadFollowedBoards();
              }
            },
            builder: (context, FollowedBoardsState state) {
              if (state is GetFollowedBoardsSuccess) {
                List<Board> results = state.boardResults.results;
                if (results.isEmpty)
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('Your follow list is empty!'),
                    ),
                  );
                else
                  return OthersBoardList(results);
              } else if (state is GetFollowedBoardsError) {
                return SliverFillRemaining(
                  child: CustomError(
                    message: "${state.error.message}\nTap to retry",
                    onTap: _loadFollowedBoards,
                  ),
                );
              }
              return SliverFillRemaining(
                child: Loading(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<FollowedBoardsBloc>(),
                child: SearchPage(),
              ),
            ),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
