import 'package:http/http.dart';
import 'package:uniq/src/repositories/profile_repository.dart';
import 'package:uniq/src/shared/constants.dart';

class ProfileApiProvider implements ProfileRepository {
  Client client = Client();

  final String _apiUrl = '$host:$backendPort/profile';

  @override
  Future getProfileDetails() async {
    // TODO: Implement get method;
  }

  @override
  Future putProfileDetails() async {
    // TODO: Implement put method;
  }
}
