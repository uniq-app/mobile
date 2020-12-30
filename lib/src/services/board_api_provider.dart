import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uniq/src/services/http_interceptor.dart';

// TODO: Add override annotations
class BoardApiProvider implements BoardRepository {
  Client client = HttpClientWithInterceptor.build(
    interceptors: [
      LoggingInterceptor(),
    ],
  );
  final storage = new FlutterSecureStorage();

  final String _apiUrl = 'http://192.168.43.223:8080/boards';
  //final String _apiUrl = 'http://10.0.2.2:8080/boards';

  Future<BoardResults> getBoards(String ownerId) async {
    final response = await client.get('$_apiUrl?creator=$ownerId');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      print("Boards - Failed to load boards");
      throw Exception('Failed to load boards');
    }
  }

  Future<List<Photo>> getBoardPhotos(String boardId) async {
    final response = await client.get('$_apiUrl/$boardId/photos');
    if (response.statusCode == 200) {
      List<Photo> photos = new List();
      var body = json.decode(response.body);
      body.forEach((el) => photos.add(Photo.fromJson(el)));
      return photos;
    } else {
      print("Boards - Failed to load photos");
      throw Exception('Failed to load photos');
    }
  }

  Future<dynamic> postPhotos(List<String> photos, String boardId) async {
    var photosMapped = photos.map((e) => {"value": e}).toList();
    String body = json.encode(photosMapped);
    var headers = {"Content-Type": "application/json"};
    final response = await client.post('$_apiUrl/$boardId/photos',
        headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Success - post Photos');
    } else {
      print("Photos - Failed to load photos");
      print(response);
      throw Exception('Failed to load photos');
    }
  }

  Board selectBoard(Board board) {
    return board;
  }
}
