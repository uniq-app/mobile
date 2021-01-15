import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:uniq/src/services/auth_api_provider.dart';

class TokenInterceptor implements InterceptorContract {
  final authApiProvider = AuthApiProvider();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    String token = await authApiProvider.getToken();
    print("Current token: $token");
    data.headers['Authorization'] = "Bearer $token";
    data.headers["Content-Type"] = "application/json";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    if (data.statusCode == 401) {
      authApiProvider.deleteToken();
    }
    return data;
  }
}
