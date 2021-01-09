import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

part 'followed_boards_event.dart';
part 'followed_boards_state.dart';

class FollowedBoardsBloc
    extends Bloc<FollowedBoardsEvent, FollowedBoardsState> {
  final BoardRepository boardRepository;
  BoardResults boardResults;

  FollowedBoardsBloc({@required this.boardRepository})
      : super(FollowedBoardsInitial());

  @override
  Stream<FollowedBoardsState> mapEventToState(
    FollowedBoardsEvent event,
  ) async* {
    if (event is GetFollowedBoards) {
      yield GetFollowedBoardsLoading();
      try {
        boardResults = await boardRepository.getFollowedBoards();
        yield GetFollowedBoardsSuccess();
      } on SocketException {
        yield GetFollowedBoardsError(error: NoInternetException('No internet'));
      } on HttpException {
        yield GetFollowedBoardsError(
            error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield GetFollowedBoardsError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield GetFollowedBoardsError(
            error: NoInternetException('Unknown error'));
      }
    }
  }
}
