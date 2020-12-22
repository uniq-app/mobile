import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class FetchBoardPhotos extends PhotoEvent {
  final String boardId;
  const FetchBoardPhotos({@required this.boardId});

  @override
  List<Object> get props => [boardId];
}
