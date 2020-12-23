import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/services/board_api_provider.dart';

class PhotoApiProvider implements PhotoRepository {
  Client client = Client();
  BoardRepository boardApiProvider = BoardApiProvider();
  PhotoApiProvider();

  // Local jest na http://10.0.2.2:80/images
  // final String _apiUrl = 'http://192.168.43.223:80/images';
  static final String _apiUrl = 'http://192.168.0.107:80/images';

  static String get apiUrl => _apiUrl;

  Future postAll(List<Asset> assets, List<Board> checked) async {
    List<String> values = new List();
    for (Asset asset in assets) {
      // Collect them here
      values.add(await postImage(asset));
    }
    List<Future> futures = List();
    // Post to selected boards
    for (Board board in checked) {
      futures.add(boardApiProvider.postPhotos(values, board.id));
    }
    await Future.wait(futures);
    // Todo: xd
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Future<File> getFileFromAsset(Asset asset) async {
    ByteData byteData;
    byteData = await asset.getByteData(quality: 100);
    final File file =
        File('${(await getTemporaryDirectory()).path}/${asset.name}');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<String> postImage(Asset asset) async {
    File file = await getFileFromAsset(asset);
    var request = new MultipartRequest("POST", Uri.parse(_apiUrl));
    request.files.add(MultipartFile.fromBytes('file', file.readAsBytesSync(),
        filename: file.path.split("/").last));

    var responseStream = await request.send();
    var response = await Response.fromStream(responseStream);

    if (response.statusCode == 200) {
      return json.decode(response.body)['id'];
    } else {
      print("Photos - failed to post photos");
      throw Exception('Failed to load photos');
    }
  }
}
