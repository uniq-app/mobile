import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:uniq/src/shared/http_interceptor.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uniq/src/shared/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BoardApiProvider implements BoardRepository {
  Client client = HttpClientWithInterceptor.build(
    interceptors: [
      LoggingInterceptor(),
    ],
  );
  final storage = new FlutterSecureStorage();

  final String _apiUrl = '$host:$backendPort/boards';

  @override
  Future<BoardResults> getBoards() async {
    final response = await client.get('$_apiUrl');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load boards');
    }
  }

  Future searchForBoards(String query) async {
    final response = await client.get('$_apiUrl/search?q=$query');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw Exception('Failed to load boards');
    }
  }

  @override
  Future postBoard(Board board) async {
    String body;
    if (board.cover != '')
      body = json.encode(board.toJson());
    else
      body = json.encode(board.toJsonWithoutCover());
    print(body);

    var headers = {"Content-Type": "application/json"};
    final response =
        await client.post('$_apiUrl/', body: body, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Failed to post boards');
    }
  }

  @override
  Future putBoard(Board board) async {
    String body;
    if (board.cover != '')
      body = json.encode(board.toJson());
    else
      body = json.encode(board.toJsonWithoutCover());
    var headers = {"Content-Type": "application/json"};
    final response =
        await client.put('$_apiUrl/${board.id}', body: body, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Failed to update board');
    }
  }

  @override
  Future deleteBoard(String boardId) async {
    final response = await client.delete('$_apiUrl/$boardId');
    if (response.statusCode == 200 || response.statusCode == 204) {
    } else {
      throw Exception('Failed to delete boards');
    }
  }

  @override
  Future<List<Photo>> getBoardPhotos(String boardId) async {
    final response = await client.get('$_apiUrl/$boardId/photos');
    if (response.statusCode == 200) {
      List<Photo> photos = new List();
      var body = json.decode(response.body);
      body.forEach((el) => photos.add(Photo.fromJson(el)));
      return photos;
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Future<dynamic> putPhotos(List<String> photos, String boardId) async {
    var photosMapped = photos.map((e) => {"value": e}).toList();
    String body = json.encode(photosMapped);
    var headers = {"Content-Type": "application/json"};
    final response = await client.put('$_apiUrl/$boardId/photos',
        headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Failed to post photos');
    }
  }

  @override
  Future reorderPhotos(String boardId, List<Photo> photos) async {
    var photosMapped = photos.map((e) => e.toJson()).toList();
    String body = json.encode(photosMapped);
    var headers = {"Content-Type": "application/json"};
    final response = await client.put('$_apiUrl/$boardId/photos',
        headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Failed to reorder photos');
    }
  }

  @override
  Future deleteBoardPhoto(String boardId, Photo photo) async {
    String body = json.encode([photo.toJson()]);
    String token = await storage.read(key: "token");

    var headers = {
      "Content-Type": "application/json",
      'Authorization': "Bearer $token"
    };
    final request =
        http.Request("DELETE", Uri.parse('$_apiUrl/$boardId/photos'));
    request.headers.addAll(headers);
    request.body = body;
    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      response.stream.bytesToString().then((value) => print(value));
      throw Exception('Failed to delete photo');
    }
  }

  @override
  Future getFollowedBoards() async {
    final response = await client.get('$_apiUrl/followed');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load followed boards');
    }
  }

  @override
  Future followBoard(String boardId) async {
    final response = await client.post('$_apiUrl/$boardId/follow');
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Couldnt follow board: $boardId');
    }
  }

  @override
  Future unfollowBoard(String boardId) async {
    final response = await client.post('$_apiUrl/$boardId/unfollow');
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Couldnt unfollow board $boardId');
    }
  }
}
