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

class SelectBoard extends BoardEvent {
  final Board board;

  const SelectBoard({@required this.board});

  @override
  List<Object> get props => [board];
}