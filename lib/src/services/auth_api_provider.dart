import 'dart:convert';
import 'package:http/http.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/repositories/auth_repository.dart';

class AuthApiProvider implements AuthRepository {
  Client client = Client();

  final String _apiUrl = 'http://192.168.0.107:8080/auth';
  // final String _apiUrl = 'http://10.0.2.2:8080/auth';

  Future<BoardResults> getBoards(String ownerId) async {
    final response = await client.get('$_apiUrl?creator=$ownerId');
    if (response.statusCode == 200) {
      return BoardResults.fromJson(json.decode(response.body));
    } else {
      print("Photos - Failed to load boards");
      throw Exception('Failed to load boards');
    }
  }

  @override
  Future login(String username, String password) async {
    var credentialsMap = {"username": username, "password": password};
    String body = json.encode(credentialsMap);
    var headers = {"Content-Type": "application/json"};

    final response =
        await client.post('$_apiUrl/login', body: body, headers: headers);
    print("In auth provider: $username $password");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      //return BoardResults.fromJson(json.decode(response.body));
    } else {
      print("Login failed: ${response.statusCode}");
      throw Exception('Failed to login');
    }
  }

  @override
  Future register(String ownerId) async {
    final response = await client.get('$_apiUrl/register');
  }

  @override
  Future logout(String ownerId) async {
    final response = await client.get('$_apiUrl/logout');
  }
}
