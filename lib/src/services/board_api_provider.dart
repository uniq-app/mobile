import 'dart:convert';

import 'package:http/http.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/repositories/board_repository.dart';

class BoardApiProvider implements BoardRepository {
  Client client = Client();
  // Local jest na http://10.0.2.2:PORT/boards
  // final String _apiUrl = 'http://192.168.43.223:8080/boards';
  final String _apiUrl = 'http://192.168.0.107:8080/boards';

  Future<BoardResults> getBoards(String ownerId) async {
    print("Calling get boards");
    final response = await client.get('$_apiUrl?creator=$ownerId');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      print("Photos - Failed to load boards");
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
      print("Photos - Failed to load photos");
      throw Exception('Failed to load photos');
    }
  }

  Future<dynamic> postPhotos(List<String> photos, String boardId) async {
    var photosMapped = photos.map((e) => {"value": e}).toList();
    print(photosMapped);
    String body = json.encode(photosMapped);
    print(body);
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
