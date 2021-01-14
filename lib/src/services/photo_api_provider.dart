import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/shared/token_interceptor.dart';
import 'package:uniq/src/shared/logging_interceptor.dart';
import 'package:uniq/src/shared/constants.dart';

class PhotoApiProvider implements PhotoRepository {
  Client client = HttpClientWithInterceptor.build(
    interceptors: [
      TokenInterceptor(),
      LoggingInterceptor(),
    ],
  );

  static final String _apiUrl = "$host:$imageServicePort/images";

  static String get apiUrl => _apiUrl;

  Future<List<String>> postAll(List<Asset> assets) async {
    List<String> values = new List();
    for (Asset asset in assets) {
      var result = await postImage(asset);
      print("Result of posting single image: $result");
      values.add(result);
    }
    return values;
  }

  Future<List<String>> postAllFromCamera(List<File> images) async {
    List<String> values = new List();
    for (File file in images) {
      values.add(await postImageFromFile(file));
    }
    return values;
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body)['id'];
    } else {
      print("Failed to post photo");
      print(response);
      print(response.statusCode);
      throw Exception('Failed to post photos');
    }
  }

  Future<String> postImageFromFile(File file) async {
    var request = new MultipartRequest("POST", Uri.parse(_apiUrl));
    request.files.add(MultipartFile.fromBytes('file', file.readAsBytesSync(),
        filename: file.path.split("/").last));
    var responseStream = await request.send();
    var response = await Response.fromStream(responseStream);

    if (response.statusCode == 200) {
      return json.decode(response.body)['id'];
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
