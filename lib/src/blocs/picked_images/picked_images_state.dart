part of 'picked_images_cubit.dart';

abstract class PickedImagesState extends Equatable {
  const PickedImagesState();

  @override
  List<Object> get props => [];
}

class PickedImagesInitial extends PickedImagesState {
  final List<Asset> images = new List<Asset>();
  PickedImagesInitial();
}

class PickedImages extends PickedImagesState {
  final List<Asset> images;
  PickedImages(this.images);
}
