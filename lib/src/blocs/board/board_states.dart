import 'package:equatable/equatable.dart';
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
  BoardsError({this.error});
}

class DeleteError extends BoardState {
  final error;
  DeleteError({this.error});
}

class UpdateError extends BoardState {
  final error;
  UpdateError({this.error});
}

class BoardCreated extends BoardState {}

class BoardUpdated extends BoardState {}

class BoardDeleted extends BoardState {}
