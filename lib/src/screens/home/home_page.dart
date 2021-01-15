import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/notification/notification_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/board_list.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';
import 'package:uniq/src/shared/constants.dart';

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

  _getInitFcmTokenState() {
    return context.read<NotificationBloc>().state;
  }

  _updateFcm() {
    if (context.read<ProfileBloc>().profileDetails.notificationsEnabled) {
      print("Pushing token update");
      context.read<NotificationBloc>().add(UpdateFcm(isEnabled: true));
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

  _loadStashedBoards() async {
    context.read<BoardBloc>().add(LoadStashedBoards());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, ProfileState state) {
        if (state is PutProfileDetailsSuccess) {
          _loadUserInfo();
        }
        if (state is GetProfileDetailsSuccess) {
          if (_getInitFcmTokenState() is NotificationInitial) {
            _updateFcm();
          }
        }
      },
      child: BlocConsumer<BoardBloc, BoardState>(
        listener: (BuildContext context, BoardState state) {
          if (state is BoardCreated ||
              state is BoardDeleted ||
              state is BoardUpdated ||
              state is ReorderBoardPhotosSuccess ||
              state is DeleteBoardPhotoSuccess) {
            _loadBoards();
          } else if (state is DeleteError ||
              state is UpdateError ||
              state is CreateError ||
              state is ReorderBoardPhotosError ||
              state is DeleteBoardPhotoError) {
            _loadStashedBoards();
          }
          print("State: $state");
        },
        builder: (BuildContext context, BoardState state) {
          if (state is BoardsError) {
            final error = state.error;
            return CustomError(
              message: '${error.message}.\nTap to retry.',
              onTap: () => {
                _loadBoards(),
                _loadUserInfo(),
              },
            );
          } else if (state is BoardsLoaded) {
            final List<Board> boards = state.boardResults.results;
            return CustomScrollView(
              slivers: <Widget>[
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (BuildContext context, ProfileState state) {
                    if (state is GetProfileDetailsSuccess) {
                      return SliverAppBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        automaticallyImplyLeading: false,
                        expandedHeight: size.height * 0.085,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding:
                              EdgeInsetsDirectional.only(start: 15, bottom: 15),
                          title: SafeArea(
                            child: Row(
                              children: [
                                Text(
                                  'welcome ${state.profile.username}',
                                  style: Theme.of(context)
                                      .appBarTheme
                                      .textTheme
                                      .headline1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (state is GetProfileDetailsError) {
                      return SliverAppBar(
                        automaticallyImplyLeading: false,
                        title: InkWell(
                          child: Column(
                            children: [
                              CustomError(
                                message: "Couldn't load user details",
                              ),
                              Center(
                                child: Icon(
                                  Icons.replay_outlined,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          onTap: _loadUserInfo,
                        ),
                      );
                    }
                    return SliverAppBar(
                      automaticallyImplyLeading: false,
                      title: Loading(),
                    );
                  },
                ),
                BoardList(boards, Icon(Icons.settings), 26),
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
          return Center(
            child: Loading(),
          );
        },
      ),
    );
  }
}
