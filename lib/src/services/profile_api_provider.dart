import 'dart:convert';
import 'package:http/http.dart';
import 'package:uniq/src/models/profile_details.dart';
import 'package:uniq/src/repositories/profile_repository.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:uniq/src/shared/http_interceptor.dart';

class ProfileApiProvider implements ProfileRepository {
  Client client = HttpClientWithInterceptor.build(
    interceptors: [
      LoggingInterceptor(),
    ],
  );

  final String _apiUrl = '$host:8080/profile';

  @override
  Future getProfileDetails() async {
    final response = await client.get('$_apiUrl');
    if (response.statusCode == 200) {
      return ProfileDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile details');
    }
  }

  @override
  Future putProfileDetails() async {
    // TODO: Implement put method;
  }
}
