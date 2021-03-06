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
        yield GetFollowedBoardsSuccess(boardResults: boardResults);
      } on SocketException {
        yield GetFollowedBoardsError(error: NoInternetException());
      } on HttpException {
        yield GetFollowedBoardsError(error: NoServiceFoundException());
      } on FormatException {
        yield GetFollowedBoardsError(error: InvalidFormatException());
      } catch (e) {
        yield GetFollowedBoardsError(error: e);
      }
    }
    if (event is FollowBoard) {
      yield FollowBoardLoading();
      try {
        await boardRepository.followBoard(event.boardId);
        yield FollowBoardSuccess();
      } on SocketException {
        yield FollowBoardError(error: NoInternetException());
      } on HttpException {
        yield FollowBoardError(error: NoServiceFoundException());
      } on FormatException {
        yield FollowBoardError(error: InvalidFormatException());
      } catch (e) {
        yield FollowBoardError(error: e);
      }
    }
    if (event is UnfollowBoard) {
      yield FollowBoardLoading();
      try {
        await boardRepository.unfollowBoard(event.boardId);
        yield UnfollowBoardSuccess();
      } on SocketException {
        yield UnfollowBoardError(error: NoInternetException());
      } on HttpException {
        yield UnfollowBoardError(error: NoServiceFoundException());
      } on FormatException {
        yield UnfollowBoardError(error: InvalidFormatException());
      } catch (e) {
        yield UnfollowBoardError(error: e);
      }
    }
  }
}
