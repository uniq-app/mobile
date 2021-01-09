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
      throw Exception('Failed to activate');
    }
  }
}
