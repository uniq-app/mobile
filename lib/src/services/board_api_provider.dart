import 'dart:convert';

import 'package:http/http.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';

class BoardApiProvider {
  Client client = Client();
  // Local jest na http://10.0.2.2:PORT/boards
  // final String _apiUrl = 'http://192.168.43.223:8080/boards';
  final String _apiUrl = 'http://10.0.2.2:8080/boards';

  Future<BoardResults> getBoards(String ownerId) async {
    final response = await client.get('$_apiUrl?creator=$ownerId');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      print("Photos - Failed to load boards");
      throw Exception('Failed to load boards');
    }
  }

  Future<List<Photo>> getPhotos(String boardId) async {
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
}
