part of 'taken_images_cubit.dart';

abstract class TakenImagesState extends Equatable {
  const TakenImagesState();

  @override
  List<Object> get props => [];
}

class TakenImagesInitial extends TakenImagesState {
  final List<File> images = new List<File>();
  TakenImagesInitial();
}

class TakenImages extends TakenImagesState {
  final List<File> images;
  TakenImages(this.images);
}
