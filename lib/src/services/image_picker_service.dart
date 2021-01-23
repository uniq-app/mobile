import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/blocs/picked_images/picked_images_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerService {
  BuildContext context;
  bool mounted;
  List<Asset> _images = List();

  ImagePickerService(this.context, this.mounted);

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';
    try {
      _images = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarTitle: "Library",
          allViewTitle: "All photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#FFFFFF",
          actionBarColor: Theme.of(context).primaryColor.toHexTriplet(),
          //lightStatusBar: true,
          statusBarColor: Theme.of(context).primaryColor.toHexTriplet(),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    print("Error in image service: $error");
    storeImages();
    if (!mounted) return;
  }

  storeImages() async {
    context.read<PickedImagesCubit>().storePickedImages(_images);
  }

  List<Asset> get images => _images;
}

extension ColorX on Color {
  String toHexTriplet() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
