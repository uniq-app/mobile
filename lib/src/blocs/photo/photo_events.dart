import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/models/board.dart';

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

class PostAllPhotos extends PhotoEvent {
  final List<Asset> images;
  final List<Board> checked;
  const PostAllPhotos({@required this.images, @required this.checked});

  @override
  List<Object> get props => [images, checked];
}

class PostCoverImage extends PhotoEvent {
  final File image;
  PostCoverImage({this.image});
}

class PostSingleImage extends PhotoEvent {
  final File image;
  final List<Board> checked;
  PostSingleImage({this.image, this.checked});
}

class ClosePostDialog extends PhotoEvent {}
