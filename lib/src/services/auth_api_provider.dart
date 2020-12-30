import 'dart:convert';
import 'package:http/http.dart';
import 'package:uniq/src/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uniq/src/shared/constants.dart';

class AuthApiProvider implements AuthRepository {
  Client client = Client();
  final storage = new FlutterSecureStorage();

  final String _apiUrl = authApiUrl;

  Future storeToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String> getToken() async {
    String token = await storage.read(key: "token");
    print("Get token: $token");
    return token;
  }

  Future deleteToken() async {
    await storage.delete(key: "token");
  }

  @override
  Future login(String username, String password) async {
    print("In auth provider: $username $password");

    var credentialsMap = {"username": username, "password": password};
    String body = json.encode(credentialsMap);
    var headers = {"Content-Type": "application/json"};

    final response =
        await client.post('$_apiUrl/login', body: body, headers: headers);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // Write to local secure storage
      storeToken(body['jwt']);
    } else {
      print("Login failed: ${response.statusCode}");
      throw Exception('Failed to login');
    }
  }

  @override
  Future register(String username, String password) async {
    final response = await client.get('$_apiUrl/register');
  }

  @override
  Future logout() async {
    // todo: Need to call board service?? final response = await client.get('$_apiUrl/logout');
    return await deleteToken();
  }
}
