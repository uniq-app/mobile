import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uniq/src/repositories/notification_repository.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/logging_interceptor.dart';
import 'package:uniq/src/shared/token_interceptor.dart';

class NotificationApiProvider implements NotificationRepository {
  Client client = HttpClientWithInterceptor.build(
    interceptors: [
      LoggingInterceptor(),
      TokenInterceptor(),
    ],
  );
  final storage = new FlutterSecureStorage();

  final String _apiUrl = '$host:$backendPort/notification';

  @override
  Future updateFCM(String fcmToken) async {
    var credentialsMap = {"fcmtoken": fcmToken};
    String body = json.encode(credentialsMap);
    print("Body with token: $body");
    var headers = {"Content-Type": "application/json"};
    final response =
        await client.put('$_apiUrl/token', body: body, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Failed to send FCM');
    }
  }
}
