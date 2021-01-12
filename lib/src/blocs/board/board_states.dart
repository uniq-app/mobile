import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';

abstract class BoardState {}

// TODO: If performance issues extend Equatable for better ui rebuilding
class BoardInitialState extends BoardState {}

class BoardsLoading extends BoardState {}

class BoardsLoaded extends BoardState {
  final BoardResults boardResults;
  final List<Board> checked;
  BoardsLoaded({this.boardResults, this.checked});
}

class BoardsError extends BoardState {
  final error;
  BoardsError({@required this.error});
}

class DeleteError extends BoardState {
  final error;
  DeleteError({@required this.error});
}

class UpdateError extends BoardState {
  final error;
  UpdateError({@required this.error});
}

class CreateError extends BoardState {
  final error;
  CreateError({@required this.error});
}

class BoardCreated extends BoardState {}

class BoardUpdated extends BoardState {}

class BoardDeleted extends BoardState {}

class ReorderBoardPhotosSuccess extends BoardState {}

class ReorderBoardPhotosError extends BoardState {
  final error;
  ReorderBoardPhotosError({@required this.error});
}

class DeleteBoardPhotoLoading extends BoardState {}

class DeleteBoardPhotoSuccess extends BoardState {}

class DeleteBoardPhotoError extends BoardState {
  final error;
  DeleteBoardPhotoError({@required this.error});
}
