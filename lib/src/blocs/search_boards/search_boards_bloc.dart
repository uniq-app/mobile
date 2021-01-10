import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

part 'search_boards_event.dart';
part 'search_boards_state.dart';

class SearchBoardsBloc extends Bloc<SearchBoardsEvent, SearchBoardsState> {
  final BoardRepository boardRepository;
  BoardResults boardResults;

  SearchBoardsBloc({this.boardRepository}) : super(SearchBoardInitial());

  @override
  Stream<SearchBoardsState> mapEventToState(
    SearchBoardsEvent event,
  ) async* {
    if (event is SearchForBoards) {
      yield SearchForBoardsLoading();
      try {
        boardResults = await boardRepository.searchForBoards(event.query);
        await Future.delayed(Duration(milliseconds: 300));
        if (boardResults == null) {
          yield SearchForBoardsNotFound();
        } else {
          yield SearchForBoardsSuccess(boardResults: boardResults);
        }
      } on SocketException {
        yield SearchForBoardsError(error: NoInternetException());
      } on HttpException {
        yield SearchForBoardsError(error: NoServiceFoundException());
      } on FormatException {
        yield SearchForBoardsError(error: InvalidFormatException());
      } catch (e) {
        yield SearchForBoardsError(error: e);
      }
    }
  }
}
