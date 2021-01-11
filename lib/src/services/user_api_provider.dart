import 'dart:convert';

import 'package:http/http.dart';
import 'package:uniq/src/repositories/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uniq/src/shared/constants.dart';

class UserApiProvider implements UserRepository {
  Client client = Client();
  final storage = new FlutterSecureStorage();

  final String _apiUrl = '$host:$backendPort/user';

  @override
  Future activate(String code) async {
    var headers = {"Content-Type": "application/json"};
    final response =
        await client.put('$_apiUrl/activation/$code', headers: headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
      throw Exception('Failed to activate account');
    }
  }

  @override
  Future forgotPassword(String email) async {
    final response = await client.post('$_apiUrl/forgot/$email');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future updatePassword(
      String newPassword, oldPassword, repeatedNewPassword) async {
    var credentialsMap = {
      "newPassword": newPassword,
      "oldPassword": oldPassword,
      "repeatedNewPassword": repeatedNewPassword
    };
    String body = json.encode(credentialsMap);
    final response = await client.put('$_apiUrl/password', body: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future resendCode(String email) async {
    final response = await client.post('$_apiUrl/resend/$email');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future resetPassword(String email, String password) async {
    var credentialsMap = {"email": email, "password": password};
    String body = json.encode(credentialsMap);
    final response = await client.put('$_apiUrl/reset', body: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future updateEmail(String email) async {
    final response = await client.put('$_apiUrl/update_email/$email');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future updateUsername(String username) async {
    final response = await client.put('$_apiUrl/update/$username');
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TODO: Zwraca nowy jwt?
      return json.decode(response.body);
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future validCode(String code) async {
    final response = await client.post('$_apiUrl/valid/$code');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Something went wrong');
    }
  }
}
