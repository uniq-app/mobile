import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/models/board.dart';

abstract class PhotoRepository {
  void postAll(List<Asset> assets, List<Board> checked);
  Future<String> postImage(Asset asset);
}