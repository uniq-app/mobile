import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/models/board.dart';

abstract class PhotoRepository {
  Future<List<String>> postAll(List<Asset> assets);
  Future<String> postImage(Asset asset);
  Future<String> postImageFromFile(File file);
  Future<List<String>> postAllFromCamera(List<File> images);
}
