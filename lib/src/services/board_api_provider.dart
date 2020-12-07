import 'dart:convert';

import 'package:http/http.dart';
import 'package:uniq/src/models/board_results.dart';

class BoardApiProvider {
  Client client = Client();
  // Local jest na http://10.0.2.2:PORT/boards
  // final String _apiUrl = 'http://192.168.0.16:8080/boards/test';
  final String _apiUrl = 'http://192.168.0.16:8080/boards/test';

  Future<BoardResults> getBoards(String ownerId) async {
    final response = await client.get('$_apiUrl?creator=$ownerId');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load boards');
    }
  }
}
