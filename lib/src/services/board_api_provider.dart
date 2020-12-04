import 'dart:convert';

import 'package:http/http.dart';
import 'package:uniq/src/models/board_result.dart';

class BoardApiProvider {
  Client client = Client();
  // TODO: Api Url
  final String _apiUrl = '';

  Future<BoardResults> getBoards(String ownerId) async {
    final response = await client.get('$_apiUrl/$ownerId');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load boards');
    }
  }
}
