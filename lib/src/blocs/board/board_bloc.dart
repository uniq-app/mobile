import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final BoardRepository boardRepository;
  final PhotoRepository photoRepository;
  BoardResults boardResults;

  BoardBloc({this.boardRepository, this.photoRepository})
      : super(BoardInitialState());

  @override
  Stream<BoardState> mapEventToState(BoardEvent event) async* {
    if (event is FetchBoards) {
      yield BoardsLoading();
      try {
        boardResults = await boardRepository.getBoards();
        await Future.delayed(Duration(milliseconds: 300));
        yield BoardsLoaded(boardResults: boardResults, checked: new List());
      } on SocketException {
        yield BoardsError(error: NoInternetException());
      } on HttpException {
        yield BoardsError(error: NoServiceFoundException());
      } on FormatException {
        yield BoardsError(error: InvalidFormatException());
      } catch (e) {
        yield BoardsError(error: e);
      }
    }
    if (event is LoadStashedBoards) {
      yield BoardsLoaded(boardResults: boardResults, checked: new List());
    }
    if (event is CreateBoard) {
      yield BoardsLoading();
      try {
        if (event.coverImage != null) {
          String id = await photoRepository.postImageFromFile(event.coverImage);
          event.board.cover = id;
        }
        await boardRepository.postBoard(event.board);
        yield BoardCreated();
      } on SocketException {
        yield BoardsError(error: NoInternetException());
      } on HttpException {
        yield BoardsError(error: NoServiceFoundException());
      } on FormatException {
        yield BoardsError(error: InvalidFormatException());
      } catch (e) {
        yield BoardsError(error: e);
      }
    }

    if (event is UpdateBoard) {
      yield BoardsLoading();
      try {
        if (event.coverImage != null) {
          String id = await photoRepository.postImageFromFile(event.coverImage);
          event.board.cover = id;
        }
        await boardRepository.putBoard(event.board);
        yield BoardUpdated();
      } on SocketException {
        yield UpdateError(error: NoInternetException());
      } on HttpException {
        yield UpdateError(error: NoServiceFoundException());
      } on FormatException {
        yield UpdateError(error: InvalidFormatException());
      } catch (e) {
        yield UpdateError(error: e);
      }
    }
    if (event is DeleteBoard) {
      yield BoardsLoading();
      try {
        await boardRepository.deleteBoard(event.boardId);
        yield BoardDeleted();
      } on SocketException {
        yield DeleteError(error: NoInternetException());
      } on HttpException {
        yield DeleteError(error: NoServiceFoundException());
      } on FormatException {
        yield DeleteError(error: InvalidFormatException());
      } catch (e) {
        yield DeleteError(error: e);
      }
    }
  }
}
