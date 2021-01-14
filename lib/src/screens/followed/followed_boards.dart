import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uniq/src/blocs/followed_boards/followed_boards_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/screens/followed/search_page.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/others_board_list.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.085,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 15, bottom: 15),
              title: SafeArea(
                child: Row(
                  children: [
                    Text(
                      "followed boards",
                      style: Theme.of(context).appBarTheme.textTheme.headline1,
                    ),
                  ],
                ),
              ),
            ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size.height * 0.2,
                          child:
                              SvgPicture.asset('assets/images/empty_heart.svg'),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          'your follow list is empty',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
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
