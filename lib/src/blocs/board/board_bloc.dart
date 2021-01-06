import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final BoardRepository boardRepository;
  BoardResults boardResults;

  BoardBloc({this.boardRepository}) : super(BoardInitialState());

  @override
  Stream<BoardState> mapEventToState(BoardEvent event) async* {
    if (event is FetchBoards) {
      yield BoardsLoading();
      try {
        boardResults = await boardRepository.getBoards();
        await Future.delayed(Duration(milliseconds: 300));
        yield BoardsLoaded(boardResults: boardResults, checked: new List());
      } on SocketException {
        yield BoardsError(error: NoInternetException('No internet'));
      } on HttpException {
        yield BoardsError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield BoardsError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        yield BoardsError(error: NoInternetException('Unknown error'));
      }
    }
    if (event is CreateBoard) {
      yield BoardsLoading();
      try {
        await boardRepository.postBoard(event.board);
        yield BoardCreated();
      } on SocketException {
        yield BoardsError(error: NoInternetException('No internet'));
      } on HttpException {
        yield BoardsError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield BoardsError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield BoardsError(error: NoInternetException('Unknown error'));
      }
    }

    if (event is UpdateBoard) {
      yield BoardsLoading();
      try {
        await boardRepository.putBoard(event.board);
        yield BoardUpdated();
      } on SocketException {
        yield UpdateError(error: NoInternetException('No internet'));
      } on HttpException {
        yield UpdateError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield UpdateError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield UpdateError(error: NoInternetException('Unknown error'));
      }
    }
    if (event is DeleteBoard) {
      yield BoardsLoading();
      try {
        await boardRepository.deleteBoard(event.boardId);
        yield BoardDeleted();
      } on SocketException {
        yield DeleteError(error: NoInternetException('No internet'));
      } on HttpException {
        yield DeleteError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield DeleteError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield DeleteError(error: NoInternetException('Unknown error'));
      }
    }
  }
}
