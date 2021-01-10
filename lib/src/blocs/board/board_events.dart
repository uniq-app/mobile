import 'dart:io';
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

class LoadStashedBoards extends BoardEvent {
  @override
  List<Object> get props => [];
}

class CreateBoard extends BoardEvent {
  final Board board;
  final File coverImage;
  CreateBoard({@required this.board, this.coverImage});
  @override
  List<Object> get props => [board, coverImage];
}

class UpdateBoard extends BoardEvent {
  final Board board;
  final File coverImage;
  UpdateBoard({@required this.board, this.coverImage});
  @override
  List<Object> get props => [board];
}

class DeleteBoard extends BoardEvent {
  final String boardId;
  DeleteBoard({@required this.boardId});
  @override
  List<Object> get props => [boardId];
}
