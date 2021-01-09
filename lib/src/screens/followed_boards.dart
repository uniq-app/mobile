import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/followed_boards/followed_boards_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';
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
      body: BlocConsumer<FollowedBoardsBloc, FollowedBoardsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, FollowedBoardsState state) {
          if (state is GetFollowedBoardsSuccess) {
            List<Board> results = state.boardResults.results;
            if (results.isEmpty)
              return Center(child: Text('You are not following any boards'));
            else
              return Center(child: Text('Success'));
          } else if (state is GetFollowedBoardsError) {
            return CustomError(
              message: "${state.error.message}\n\n Tap to retry",
              onTap: _loadFollowedBoards,
            );
          }
          return Loading();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(searchPageRoute);
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
