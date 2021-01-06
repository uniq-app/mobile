import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/models/board.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();
}

class FetchBoards extends BoardEvent {
  @override
  List<Object> get props => [];
}

class CreateBoard extends BoardEvent {
  final Board board;
  CreateBoard({@required this.board});
  @override
  List<Object> get props => [board];
}

class UpdateBoard extends BoardEvent {
  final Board board;
  final String boardId;
  UpdateBoard({@required this.board, this.boardId});
  @override
  List<Object> get props => [board, boardId];
}

class DeleteBoard extends BoardEvent {
  final String boardId;
  DeleteBoard({@required this.boardId});
  @override
  List<Object> get props => [boardId];
}
