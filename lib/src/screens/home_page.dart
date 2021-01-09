import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';
import 'package:uniq/src/shared/components/board_list_element.dart';
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
    if (_getInitBoardState() is BoardInitialState) {
      _loadBoards();
    }
    if (_getInitUserInfo() is ProfileInitial) {
      _loadUserInfo();
    }
  }

  _getInitUserInfo() {
    return context.read<ProfileBloc>().state;
  }

  _getInitBoardState() {
    return context.read<BoardBloc>().state;
  }

  _loadUserInfo() async {
    context.read<ProfileBloc>().add(GetProfileDetails());
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
    return BlocConsumer<BoardBloc, BoardState>(
      listener: (BuildContext context, BoardState state) {
        if (state is BoardCreated ||
            state is BoardDeleted ||
            state is BoardUpdated) {
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
}

class BoardList extends StatelessWidget {
  final List<Board> boards;
  BoardList(this.boards);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: <Widget>[
        BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, ProfileState state) {
            // TODO: Implement profile update listener
          },
          builder: (BuildContext context, ProfileState state) {
            print("Profile state: $state");
            if (state is GetProfileDetailsSuccess) {
              return SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: false,
                floating: true,
                expandedHeight: 100.0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      EdgeInsetsDirectional.only(start: 15, bottom: 15),
                  title: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome ${state.profile.username}',
                          style:
                              Theme.of(context).appBarTheme.textTheme.headline6,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox.fromSize(
                            size: size * 0.2,
                            child: UserIconButton(
                              iconSize: 1.0,
                              radius: 30,
                              imageLink:
                                  "https://images.unsplash.com/photo-1491555103944-7c647fd857e6?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
                              color: Colors.white,
                              margin: 20,
                              push: () {
                                context
                                    .read<PageCubit>()
                                    .setPage(PageState.profilePage);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /* 
                  background: Row(
                    children: [
                      Text('Welcome ${state.profile.username}'),
                      Container(
                        alignment: Alignment.centerRight,
                        child: UserIconButton(
                          iconSize: 1.0,
                          radius: 30,
                          imageLink:
                              "https://images.unsplash.com/photo-1491555103944-7c647fd857e6?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
                          color: Colors.white,
                          margin: 20,
                          push: () {
                            context
                                .read<PageCubit>()
                                .setPage(PageState.profilePage);
                          },
                        ),
                      ),
                    ],
                  ),
                  */
                ),
              );
            } else if (state is GetProfileDetailsError) {
              return SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: false,
                floating: true,
                title: CustomError(
                  message: "Couldnt load profile, Tap to try again",
                  onTap: () =>
                      {context.read<ProfileBloc>().add(GetProfileDetails())},
                ),
              );
            }
            return SliverAppBar(
              automaticallyImplyLeading: false,
              title: Loading(),
              pinned: false,
              floating: true,
            );
          },
        ),
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
