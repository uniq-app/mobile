import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:uniq/src/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/logging_interceptor.dart';

class AuthApiProvider implements AuthRepository {
  Client client = HttpClientWithInterceptor.build(
    interceptors: [
      LoggingInterceptor(),
    ],
  );
  final storage = new FlutterSecureStorage();

  final String _apiUrl = '$host:$backendPort/auth';

  Future storeToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String> getToken() async {
    String token = await storage.read(key: "token");
    return token;
  }

  Future deleteToken() async {
    await storage.delete(key: "token");
  }

  @override
  Future login(String email, String password) async {
    var credentialsMap = {"email": email, "password": password};
    String body = json.encode(credentialsMap);
    var headers = {"Content-Type": "application/json"};
    final response =
        await client.post('$_apiUrl/login', body: body, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var body = json.decode(response.body);
      // Write to local secure storage
      storeToken(body['jwt']);
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future register(String username, String email, String password) async {
    var credentialsMap = {
      "username": username,
      "email": email,
      "password": password
    };
    String body = json.encode(credentialsMap);
    var headers = {"Content-Type": "application/json"};
    final response =
        await client.post('$_apiUrl/register', body: body, headers: headers);

    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
      if (response.statusCode == 409) throw Exception('Email already in use');
      throw Exception('Failed to register');
    }
  }

  @override
  Future logout() async {
    await deleteToken();
    await client.post('$_apiUrl/logout');
  }
}
