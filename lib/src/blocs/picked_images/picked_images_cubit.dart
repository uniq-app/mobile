import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

part 'picked_images_state.dart';

class PickedImagesCubit extends Cubit<List<Asset>> {
  PickedImagesCubit() : super(new List<Asset>());

  void storePickedImages(List<Asset> images) {
    emit(images);
  }
}
