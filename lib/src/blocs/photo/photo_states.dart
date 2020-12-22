import 'package:equatable/equatable.dart';
import 'package:uniq/src/models/photo.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotosLoading extends PhotoState {}

class PhotosLoaded extends PhotoState {
  final List<Photo> photos;
  PhotosLoaded({this.photos});

  @override
  List<Object> get props => [photos];
}

class PhotosError extends PhotoState {
  final error;
  PhotosError({this.error});

  @override
  List<Object> get props => [error];
}
